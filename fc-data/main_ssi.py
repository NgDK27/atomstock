import asyncio
from fastapi import FastAPI, HTTPException, WebSocket, WebSocketDisconnect, status
from fastapi.websockets import WebSocketState
from pydantic import BaseModel
from datetime import datetime, timedelta
from ssi_fc_data import fc_md_client, model
from ssi_fc_data.fc_md_stream import MarketDataStream
import config
import os
from dotenv import load_dotenv
from pathlib import Path
import psycopg2
import redis
import json
from contextlib import asynccontextmanager
from collections import defaultdict
import threading
from queue import Queue, Empty
import time
from fastapi.middleware.cors import CORSMiddleware

import sys

if sys.platform.startswith('win'):
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

# Load environment variables
project_root = Path(__file__).parent.parent.parent
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

DB_HOST = os.getenv('HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('USER')
DB_PASSWORD = os.getenv('PASSWORD')

# Initialize cache
redis_client = redis.Redis(host='localhost', port=6379, db=0)

# Initialize the client
client = fc_md_client.MarketDataClient(config)

def get_symbols():
    stock_symbols = []
    index_symbols = []

    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

    cursor = conn.cursor()

    try:
        cursor.execute("""
            SELECT s.symbol, s.en_name, m.name 
            FROM stocks s 
            JOIN markets m ON s.market_id = m.id
        """)
        stock_symbols = [(row[0], row[1], row[2]) for row in cursor.fetchall()]

        cursor.execute("""
            SELECT i.symbol, m.name 
            FROM indexes i 
            JOIN markets m ON i.market_id = m.id
        """)
        index_symbols = [(row[0], row[1]) for row in cursor.fetchall()]

    except Exception as error:
        print("Error while fetching symbols:", error)
    finally:
        cursor.close()
        conn.close()

    return stock_symbols, index_symbols

stocks, indexes = get_symbols()


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"], 
)

class StockPriceRequest(BaseModel):
    symbol: str
    range: str

def get_cache_key(symbol: str, start_date: datetime, end_date: datetime):
    return f"stock_data:{symbol}_{start_date.isoformat()}_{end_date.isoformat()}"

def get_date_range(range: str):
    end_date = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    if range == '1d':
        start_date = end_date
    elif range == '1w':
        start_date = end_date - timedelta(days=7)
    elif range == '1m':
        start_date = end_date - timedelta(days=30)
    elif range == '3m':
        start_date = end_date - timedelta(days=3*30)
    elif range == '6m':
        start_date = end_date - timedelta(days=6*30)
    elif range == '1y':
        start_date = end_date - timedelta(days=365)
    elif range == '5y':
        start_date = end_date - timedelta(days=5*365)
    else:
        raise ValueError("Invalid range. Use '1d', '1w', '1m', '3m', '6m', 1y', or '5y'.")
    return start_date, end_date

async def fetch_intraday_data(symbol: str, start_date: datetime, end_date: datetime, range: str):
    counter = 0
    response = client.intraday_ohlc(
        config,
        model.intraday_ohlc(
            symbol,
            start_date.strftime('%d/%m/%Y'),
            end_date.strftime('%d/%m/%Y'),
            pageIndex=1,
            pageSize=1000,
            ascending=True,
            resolution=1
        )
    )

    while response['status'] != 'Success' and range =='1d' and counter < 3:
        counter += 1
        start_date -= timedelta(days=1)
        end_date -= timedelta(days=1)
        response = client.intraday_ohlc(
            config,
            model.intraday_ohlc(
                symbol,
                start_date.strftime('%d/%m/%Y'),
                end_date.strftime('%d/%m/%Y'),
                pageIndex=1,
                pageSize=1000,
                ascending=True,
                resolution=1
            )
        )

    if response['status'] == 'Success':
        return [{'TradingDate': item['TradingDate'], 'Time': item['Time'], 'ClosePrice': item['Close']} for item in response['data']] 
    else: 
        return []
    
async def fetch_daily_data(symbol: str, start_date: datetime, end_date: datetime, is_index: bool):
    if not is_index:
        response = client.daily_stock_price(
            config,
            model.daily_stock_price(
                symbol,
                fromDate=start_date.strftime('%d/%m/%Y'),
                toDate=end_date.strftime('%d/%m/%Y'),
                pageIndex=1,
                pageSize=1000
            )
        )
    else:
        response = client.daily_index(
            config,
            model.daily_index(
                '',
                symbol,
                fromDate=start_date.strftime('%d/%m/%Y'),
                toDate=end_date.strftime('%d/%m/%Y'),
                pageIndex=1,
                pageSize=1000
            )
        )

    if response['status'] != 'Success':
        return []
    
    time.sleep(1)
    if is_index:
        return [{'TradingDate': item['TradingDate'], 'IndexValue': item['IndexValue']} for item in response['data']]
    else:
        return [{'TradingDate': item['TradingDate'], 'ClosePrice': item['ClosePrice']} for item in response['data']]

async def fetch_stock_prices(symbol: str, start_date: datetime, end_date: datetime, range: str):
    cache_key = get_cache_key(symbol, start_date, end_date)
    cache_data = redis_client.get(cache_key)

    if cache_data:
        return json.loads(cache_data)

    is_index = symbol in [index[0] for index in indexes]
    all_data = []

    if range in ['1d', '1w']:
        all_data = await fetch_intraday_data(symbol, start_date, end_date, range)
    else:
        current_start = start_date
        tasks = []
        while current_start < end_date:
            current_end = min(current_start + timedelta(days=30), end_date)
            tasks.append(fetch_daily_data(symbol, current_start, current_end, is_index))
            current_start = current_end + timedelta(days=1)

        chunk_results = await asyncio.gather(*tasks)
        for chunk in chunk_results:
            all_data.extend(chunk)
        
        all_data = sorted(all_data, key=lambda x: datetime.strptime(x['TradingDate'], '%d/%m/%Y'))

    redis_client.setex(cache_key, 60*60*24, json.dumps(all_data))

    return all_data




@app.get("/ticker/{symbol}")
async def get_stock_details(symbol: str, range: str = "1d"):
    try:
        is_index = symbol in [index[0] for index in indexes]
        
        if is_index:
            info = next((index for index in indexes if index[0] == symbol), None)
            if not info:
                raise HTTPException(status_code=404, detail="Index not found")
            name = symbol
            market = info[1]

        else:
            info = next((stock for stock in stocks if stock[0] == symbol), None)
            if not info:
                raise HTTPException(status_code=404, detail="Stock not found")
            name = info[1]
            market = info[2]
         
        start_date, end_date = get_date_range(range)
        historical_data = await fetch_stock_prices(symbol, start_date, end_date, range)

        return {
            "symbol": symbol,
            "name": name,
            "market": market,
            "historical_data": historical_data
        }
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
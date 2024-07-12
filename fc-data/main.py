import asyncio
import aiohttp
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime, timedelta
from ssi_fc_data import fc_md_client, model
import config
import os
from dotenv import load_dotenv
from pathlib import Path
import psycopg2
import redis
import json

app = FastAPI()

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
    stock_data = []
    index_symbols = []
    index_data = []

    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

    cursor = conn.cursor()

    try:
        # Fetch stocks symbols with their names and markets
        cursor.execute("""
            SELECT s.symbol, s.en_name, m.name 
            FROM stocks s 
            JOIN markets m ON s.market_id = m.id
        """)
        stock_data = cursor.fetchall()
        stock_symbols = [(row[0], row[1], row[2]) for row in stock_data]

        # Fetch indexes symbols with their markets
        cursor.execute("""
            SELECT i.symbol, m.name 
            FROM indexes i 
            JOIN markets m ON i.market_id = m.id
        """)
        index_data = cursor.fetchall()
        index_symbols = [(row[0], row[1]) for row in index_data]

    except Exception as error:
        print("Error while fetching symbols:", error)
    finally:
        cursor.close()
        conn.close()

    return stock_symbols, index_symbols

stocks, indexes = get_symbols()

# for s in stocks:
#     print(s[0], end=', ')

class StockPriceRequest(BaseModel):
    symbol: str
    range: str 
    name: str
    market: str

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

    return [{'TradingDate': item['TradingDate'], 'Time': item['Time'], 'ClosePrice': item['Close']} for item in response['data']]


async def fetch_one_intraday_data(symbol: str, start_date: datetime, end_date: datetime, range: str):
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
    
    while response['status'] != 'Success':
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

    return [{'TradingDate': item['TradingDate'], 'Time': item['Time'], 'Open': item['Open'], 'High': item['High'], 'Low': item['Low'], 'ClosePrice': item['Close'], 'Volume': item['Volume']} for item in response['data']]


async def fetch_daily_data(symbol: str, start_date: datetime, end_date: datetime, is_index: bool, main_market = False):
    if main_market:
        print(symbol)
        while True:
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
            
            if response['status'] == 'Success':
                break
            else:
                start_date -= timedelta(days=1)
                end_date -= timedelta(days=1)
            
        # Return data
        if is_index:
            return [{'TradingDate': item['TradingDate'], 'IndexValue': item['IndexValue'], 'Change': item['Change'], 'RatioChange': item['RatioChange'], 'TotalMatchVol': item['TotalMatchVol']} for item in response['data']]
        else:
            return [{'TradingDate': item['TradingDate'], 'ClosePrice': item['ClosePrice'], 'PriceChange': item['PriceChange'], 'PerPriceChange': item['PerPriceChange'], 'TotalMatchVol': item['TotalMatchVol']} for item in response['data']]

    else:
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

        if is_index:
            return [{'TradingDate': item['TradingDate'], 'IndexValue': item['IndexValue']} for item in response['data']]
        else:
            return [{'TradingDate': item['TradingDate'], 'ClosePrice': item['ClosePrice']} for item in response['data']]


async def fetch_stock_prices(symbol: str, start_date: datetime, end_date: datetime, range: str):
    cache_key = get_cache_key(symbol, start_date, end_date)
    cache_data = redis_client.get(cache_key)

    if cache_data:
        return json.loads(cache_data)

    is_index = symbol in ['VNIndex', 'VN30', 'HNXIndex', 'HNX30', 'HNXUpcomIndex']
    all_data = []

    if range == '1d':
        all_data = await fetch_one_intraday_data(symbol, start_date, end_date, range)
    elif range == '1w':
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

    redis_client.setex(cache_key, 60*60*24, json.dumps(all_data))

    return all_data

@app.get("/historical_prices/")
async def get_stock_prices(request: StockPriceRequest):
    try:
        start_date, end_date = get_date_range(request.range)
        data = await fetch_stock_prices(request.symbol, start_date, end_date, request.range)
        # stock_info = next((stock for stock in stocks if stock[0] == request.symbol), None)
        name = request.name
        market = request.market  
        return {"symbol": request.symbol, "name": name, "market": market, "data": data}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")


async def fetch_latest_data(symbols, is_index=False):
    today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    tasks = []
    for symbol in symbols:
        tasks.append(fetch_daily_data(symbol, today, today, is_index, main_market = True))
    return await asyncio.gather(*tasks)


@app.get("/market/")
async def market():
    try:
        # Fetch latest data for stocks and indexes
        stock_data = await fetch_latest_data([s[0] for s in stocks])
        index_data = await fetch_latest_data([i[0] for i in indexes], is_index=True)

        # Process stock data
        processed_stocks = []
        for stock, data in zip(stocks, stock_data):
            if data and len(data) > 0:  # Check if data is not empty
                symbol, name, market = stock
                latest_data = data[0]  
                processed_stocks.append({
                    'symbol': symbol,
                    'name': name,
                    'market': market,
                    'close_price': float(latest_data['ClosePrice']),
                    'percent_change': float(latest_data['PerPriceChange']),
                    'price_change': float(latest_data['PriceChange']),
                    'trading_volume': int(latest_data['TotalMatchVol']),
                })

        # Sort stocks by percent change
        sorted_stocks = sorted(processed_stocks, key=lambda x: x['percent_change'], reverse=True)
        top_performers = sorted_stocks[:3]
        top_decliners = sorted_stocks[-3:]

        # Process index data
        processed_indexes = []
        for index, data in zip(indexes, index_data):
            if data and len(data) > 0:  # Check if data is not empty
                symbol, market = index
                latest_data = data[0]  
                processed_indexes.append({
                    'symbol': symbol,
                    'market': market,
                    'index_value': float(latest_data['IndexValue']),
                    'percent_change': float(latest_data['RatioChange']),
                    'change': float(latest_data['Change']),
                    'total_volume': int(latest_data['TotalMatchVol']),
                })

        return {
            "indexes": processed_indexes,
            "top_performers": top_performers,
            "top_decliners": top_decliners
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
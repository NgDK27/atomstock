import asyncio
from fastapi import FastAPI, HTTPException, WebSocket, WebSocketDisconnect, status
from fastapi.websockets import WebSocketState
from pydantic import BaseModel
from datetime import datetime, timedelta
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
import random
import math
from fastapi.middleware.cors import CORSMiddleware

# Import centralized symbol configuration
from symbols_config import get_all_symbols, get_symbol_info, is_valid_symbol

import sys

if sys.platform.startswith('win'):
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

# Load environment variables
project_root = Path(__file__).parent.parent.parent
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

DB_HOST = os.getenv('HOST') or 'localhost'
DB_NAME = os.getenv('DB_NAME') or 'capstone'
DB_USER = os.getenv('USER') or 'quando'
DB_PASSWORD = os.getenv('PASSWORD') or '808225'

# Initialize cache
redis_client = redis.Redis(host='localhost', port=6379, db=0)

def get_symbols():
    """Get symbols from database or fallback to configured symbols"""
    stock_symbols = []
    index_symbols = []

    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )

        cursor = conn.cursor()

        try:
            # Get configured symbols for comparison
            config_stocks, config_indexes = get_all_symbols()
            config_stock_symbols = [s[0] for s in config_stocks]
            config_index_symbols = [i[0] for i in config_indexes]

            # Query database for stocks, but only include those in our config
            cursor.execute("""
                SELECT s.symbol, s.en_name, m.name 
                FROM stocks s 
                JOIN markets m ON s.market_id = m.id
                WHERE s.symbol = ANY(%s)
                ORDER BY s.symbol
            """, (config_stock_symbols,))
            db_stocks = cursor.fetchall()

            # Query database for indexes, but only include those in our config
            cursor.execute("""
                SELECT i.symbol, m.name 
                FROM indexes i 
                JOIN markets m ON i.market_id = m.id
                WHERE i.symbol = ANY(%s)
                ORDER BY i.symbol
            """, (config_index_symbols,))
            db_indexes = cursor.fetchall()

            # Use database data if available, otherwise fall back to config
            if db_stocks:
                stock_symbols = [(row[0], row[1], row[2]) for row in db_stocks]
            else:
                stock_symbols = config_stocks

            if db_indexes:
                index_symbols = [(row[0], row[1]) for row in db_indexes]
            else:
                index_symbols = config_indexes

            print(f"📊 Using database symbols: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

        except Exception as error:
            print("Error while fetching symbols from database:", error)
            # Use configured symbols as fallback
            stock_symbols, index_symbols = get_all_symbols()
            print(f"📊 Using configured fallback symbols: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

        finally:
            cursor.close()
            conn.close()

    except Exception as db_error:
        print(f"Database connection error: {db_error}")
        # Use configured symbols as fallback
        stock_symbols, index_symbols = get_all_symbols()
        print(f"📊 Using configured symbols: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

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
    return f"mock_stock_data:{symbol}_{start_date.isoformat()}_{end_date.isoformat()}"

def get_date_range(time_range: str):
    end_date = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    if time_range == '1d':
        start_date = end_date
    elif time_range == '1w':
        start_date = end_date - timedelta(days=7)
    elif time_range == '1m':
        start_date = end_date - timedelta(days=30)
    elif time_range == '3m':
        start_date = end_date - timedelta(days=3*30)
    elif time_range == '6m':
        start_date = end_date - timedelta(days=6*30)
    elif time_range == '1y':
        start_date = end_date - timedelta(days=365)
    elif time_range == '5y':
        start_date = end_date - timedelta(days=5*365)
    else:
        raise ValueError("Invalid range. Use '1d', '1w', '1m', '3m', '6m', '1y', or '5y'.")
    return start_date, end_date

def generate_base_price(symbol: str):
    """Generate a consistent base price for each symbol"""
    # Use symbol hash to ensure consistent prices across requests
    hash_val = abs(hash(symbol)) % 1000000

    # Check if it's an index
    if symbol in [index[0] for index in indexes]:
        # Index values typically 500-1500
        return 500 + (hash_val % 1000)
    else:
        # Stock prices typically 10,000 - 500,000 VND
        return 10000 + (hash_val % 490000)

def generate_price_movement(base_price: float, days_ago: int, is_intraday: bool = False):
    """Generate realistic price movement based on days ago"""
    # Use a simple random walk with some trending
    random.seed(hash(f"{base_price}_{days_ago}"))

    if is_intraday:
        # Intraday movements are smaller
        daily_volatility = 0.02  # 2% daily volatility
        hourly_volatility = daily_volatility / 8  # Divide by trading hours
        return base_price * (1 + random.gauss(0, hourly_volatility))
    else:
        # Daily movements
        daily_volatility = 0.03  # 3% daily volatility
        # Add some trending (slight upward bias over time)
        trend = -0.0001 * days_ago  # Slight downward trend as we go back in time
        return base_price * (1 + random.gauss(trend, daily_volatility))

async def fetch_mock_intraday_data(symbol: str, start_date: datetime, end_date: datetime, time_range: str):
    """Generate mock intraday data"""
    print(f"🎭 Generating mock intraday data for {symbol}")

    base_price = generate_base_price(symbol)
    data = []

    current_date = start_date
    while current_date <= end_date:
        # Skip weekends
        if current_date.weekday() < 5:  # Monday=0, Sunday=6
            # Generate data for trading hours (9:00 - 15:00)
            for hour in range(9, 16):
                for minute in [0, 15, 30, 45]:  # 15-minute intervals
                    time_str = f"{hour:02d}:{minute:02d}:00"

                    # Include hour and minute in the seed for intraday variation
                    time_seed = hour * 100 + minute
                    days_ago = (datetime.now().date() - current_date.date()).days
                    close_price = generate_price_movement_intraday(base_price, days_ago, time_seed)

                    data.append({
                        'TradingDate': current_date.strftime('%d/%m/%Y'),
                        'Time': time_str,
                        'ClosePrice': float(round(close_price, 2))  # Ensure float
                    })

        current_date += timedelta(days=1)

    return data

def generate_price_movement_intraday(base_price: float, days_ago: int, time_seed: int):
    """Generate realistic intraday price movement"""
    # Use time_seed for intraday variation
    random.seed(hash(f"{base_price}_{days_ago}_{time_seed}"))

    hourly_volatility = 0.02 / 8  # 2% daily volatility divided by trading hours
    trend = -0.0001 * days_ago
    return base_price * (1 + random.gauss(trend, hourly_volatility))

async def fetch_mock_daily_data(symbol: str, start_date: datetime, end_date: datetime, is_index: bool):
    """Generate mock daily data"""
    print(f"🎭 Generating mock daily data for {symbol} (index: {is_index})")

    base_price = generate_base_price(symbol)
    data = []

    current_date = start_date
    while current_date <= end_date:
        # Skip weekends
        if current_date.weekday() < 5:  # Monday=0, Sunday=6
            days_ago = (datetime.now().date() - current_date.date()).days
            price = generate_price_movement(base_price, days_ago)

            if is_index:
                data.append({
                    'TradingDate': current_date.strftime('%d/%m/%Y'),
                    'IndexValue': float(round(price, 2))  # Ensure float
                })
            else:
                data.append({
                    'TradingDate': current_date.strftime('%d/%m/%Y'),
                    'ClosePrice': float(round(price, 2))  # Ensure float
                })

        current_date += timedelta(days=1)

    return data

async def fetch_stock_prices(symbol: str, start_date: datetime, end_date: datetime, time_range: str):
    """Fetch mock stock prices with caching"""
    cache_key = get_cache_key(symbol, start_date, end_date)
    cache_data = redis_client.get(cache_key)

    if cache_data:
        print(f"📦 Using cached data for {symbol}")
        return json.loads(cache_data)

    is_index = symbol in [index[0] for index in indexes]

    print(f"🎭 Generating fresh mock data for {symbol} (range: {time_range})")

    if time_range in ['1d', '1w']:
        all_data = await fetch_mock_intraday_data(symbol, start_date, end_date, time_range)
    else:
        all_data = await fetch_mock_daily_data(symbol, start_date, end_date, is_index)

    # Sort by date
    all_data = sorted(all_data, key=lambda x: datetime.strptime(x['TradingDate'], '%d/%m/%Y'))

    # Cache for 1 hour (shorter for mock data to see changes during development)
    redis_client.setex(cache_key, 60*60, json.dumps(all_data))

    return all_data

@app.get("/ticker/{symbol}")
async def get_stock_details(symbol: str, range: str = "1d", time_range: str = None):
    try:
        # Handle both 'range' and 'time_range' parameters for backward compatibility
        actual_range = time_range if time_range is not None else range
        print(f"🔍 Processing request for symbol: {symbol}, range: {actual_range}")

        # Check if symbol is valid using centralized config
        if not is_valid_symbol(symbol):
            print(f"❌ Symbol not found: {symbol}")
            available_symbols = [s[0] for s in stocks] + [i[0] for i in indexes]
            print(f"Available symbols: {available_symbols[:20]}...")
            raise HTTPException(status_code=404, detail=f"Symbol '{symbol}' not found. Available symbols: {len(available_symbols)} total")

        # Get symbol info from centralized config
        symbol_info = get_symbol_info(symbol)
        if not symbol_info:
            raise HTTPException(status_code=404, detail="Symbol information not found")

        is_index = symbol_info['type'] == 'index'
        name = symbol_info.get('name', symbol)
        market = symbol_info['market']

        start_date, end_date = get_date_range(actual_range)
        historical_data = await fetch_stock_prices(symbol, start_date, end_date, actual_range)

        print(f"✅ Returning {len(historical_data)} data points for {symbol}")

        return {
            "symbol": symbol,
            "name": name,
            "market": market,
            "type": symbol_info['type'],
            "historical_data": historical_data
        }
    except ValueError as e:
        print(f"❌ ValueError: {e}")
        raise HTTPException(status_code=400, detail=str(e))
    except HTTPException:
        raise
    except Exception as e:
        print(f"❌ Unexpected error in get_stock_details for {symbol}: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@app.get("/")
async def root():
    return {
        "message": "Vietnamese Stock Market Data API",
        "version": "3.0.0",
        "mode": "vietnamese_market_comprehensive",
        "available_stocks": len(stocks),
        "available_indexes": len(indexes),
        "sample_stocks": [s[0] for s in stocks[:10]],
        "sample_indexes": [i[0] for i in indexes[:5]],
        "markets": ["HOSE", "HNX", "UPCOM"]
    }

@app.get("/symbols")
async def get_available_symbols():
    """Get all available symbols"""
    return {
        "stocks": [{"symbol": s[0], "name": s[1], "market": s[2]} for s in stocks],
        "indexes": [{"symbol": i[0], "market": i[1]} for i in indexes],
        "total_symbols": len(stocks) + len(indexes),
        "markets": {
            "HOSE": len([s for s in stocks if s[2] == "HOSE"]) + len([i for i in indexes if i[1] == "HOSE"]),
            "HNX": len([s for s in stocks if s[2] == "HNX"]) + len([i for i in indexes if i[1] == "HNX"]),
            "UPCOM": len([s for s in stocks if s[2] == "UPCOM"]) + len([i for i in indexes if i[1] == "UPCOM"])
        }
    }

@app.get("/markets/{market}")
async def get_symbols_by_market(market: str):
    """Get symbols filtered by market (HOSE, HNX, UPCOM)"""
    market = market.upper()

    if market not in ["HOSE", "HNX", "UPCOM"]:
        raise HTTPException(status_code=400, detail="Invalid market. Use HOSE, HNX, or UPCOM")

    market_stocks = [{"symbol": s[0], "name": s[1], "market": s[2]} for s in stocks if s[2] == market]
    market_indexes = [{"symbol": i[0], "market": i[1]} for i in indexes if i[1] == market]

    return {
        "market": market,
        "stocks": market_stocks,
        "indexes": market_indexes,
        "total": len(market_stocks) + len(market_indexes)
    }

@app.delete("/cache/clear")
async def clear_cache():
    """Clear all cached data"""
    try:
        redis_client.flushdb()
        return {"message": "Cache cleared successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to clear cache: {str(e)}")

@app.delete("/cache/symbol/{symbol}")
async def clear_symbol_cache(symbol: str):
    """Clear cache for specific symbol"""
    try:
        pattern = f"mock_stock_data:{symbol}_*"
        keys = redis_client.keys(pattern)
        if keys:
            redis_client.delete(*keys)
        return {"message": f"Cache cleared for symbol {symbol}", "keys_deleted": len(keys)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to clear cache for {symbol}: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    print("🚀 Starting Vietnamese Stock Market Data API...")
    print(f"📊 Loaded {len(stocks)} stocks and {len(indexes)} indexes")
    print(f"📋 Stock samples: {[s[0] for s in stocks[:10]]}")
    print(f"📋 Index samples: {[i[0] for i in indexes]}")
    print(f"🏛️ Markets: HOSE, HNX, UPCOM")
    uvicorn.run(app, host="0.0.0.0", port=8000)
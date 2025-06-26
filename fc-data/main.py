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
from symbols_config import get_all_symbols, get_symbol_info, is_valid_symbol, get_base_price

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
                stock_symbols = [(s[0], s[1], s[2]) for s in config_stocks]

            if db_indexes:
                index_symbols = [(row[0], row[1]) for row in db_indexes]
            else:
                index_symbols = [(i[0], i[1]) for i in config_indexes]

            print(f"📊 Using database symbols: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

        except Exception as error:
            print("Error while fetching symbols from database:", error)
            # Use configured symbols as fallback
            config_stocks, config_indexes = get_all_symbols()
            stock_symbols = [(s[0], s[1], s[2]) for s in config_stocks]
            index_symbols = [(i[0], i[1]) for i in config_indexes]
            print(f"📊 Using configured fallback symbols: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

        finally:
            cursor.close()
            conn.close()

    except Exception as db_error:
        print(f"Database connection error: {db_error}")
        # Use configured symbols as fallback
        config_stocks, config_indexes = get_all_symbols()
        stock_symbols = [(s[0], s[1], s[2]) for s in config_stocks]
        index_symbols = [(i[0], i[1]) for i in config_indexes]
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

def get_current_realtime_price(symbol: str):
    """Get the actual current price from real-time producer via Redis"""
    try:
        # Try to get current price from Redis (set by producer)
        is_index = symbol in [index[0] for index in indexes]

        if is_index:
            current_price_key = f"current_index_price:{symbol}"
        else:
            current_price_key = f"current_stock_price:{symbol}"

        cached_price = redis_client.get(current_price_key)

        if cached_price:
            return float(cached_price)
        else:
            # Fallback to base price if no real-time data available
            base_price = get_base_price(symbol)
            if base_price:
                print(f"⚠️ No real-time price for {symbol}, using base price: {base_price}")
                return base_price
            else:
                print(f"❌ No base price configured for {symbol}")
                return 10000.0  # Emergency fallback

    except Exception as e:
        print(f"❌ Error getting current price for {symbol}: {e}")
        base_price = get_base_price(symbol)
        return base_price if base_price else 10000.0

def generate_smooth_trend(base_price: float, current_price: float, total_points: int, is_index: bool):
    """Generate a smooth trend from base price to current price with realistic fluctuations"""
    trend_data = []

    # Create a smooth transition curve from base to current price
    for i in range(total_points):
        progress = i / (total_points - 1) if total_points > 1 else 1.0

        # Use a slight S-curve for more natural progression
        smooth_progress = 3 * progress**2 - 2 * progress**3

        # Interpolate between base and current price
        trend_price = base_price + (current_price - base_price) * smooth_progress

        # Add small random fluctuations around the trend
        if is_index:
            daily_volatility = trend_price * 0.005  # ±0.5% daily volatility for indexes
        else:
            daily_volatility = trend_price * 0.015  # ±1.5% daily volatility for stocks

        # Use consistent randomness based on point index
        random.seed(hash(f"trend_{i}") % 2147483647)
        fluctuation = random.uniform(-daily_volatility, daily_volatility)

        final_price = trend_price + fluctuation
        trend_data.append(final_price)

    return trend_data

async def fetch_mock_intraday_data(symbol: str, start_date: datetime, end_date: datetime, time_range: str):
    """Generate realistic intraday data with smooth trends"""
    print(f"🎭 Generating mock intraday data for {symbol}")

    base_price = get_base_price(symbol)
    current_realtime_price = get_current_realtime_price(symbol)
    is_index = symbol in [index[0] for index in indexes]

    if not base_price:
        print(f"❌ No base price for {symbol}")
        return []

    data = []

    # Calculate total points
    total_points = 0
    temp_date = start_date
    while temp_date <= end_date:
        if temp_date.weekday() < 5:
            for hour in range(9, 16):
                for minute in [0, 15, 30, 45]:
                    total_points += 1
        temp_date += timedelta(days=1)

    # Generate smooth trend prices
    trend_prices = generate_smooth_trend(base_price, current_realtime_price, total_points, is_index)

    point_index = 0
    current_date = start_date

    while current_date <= end_date:
        if current_date.weekday() < 5:  # Skip weekends
            for hour in range(9, 16):
                for minute in [0, 15, 30, 45]:
                    time_str = f"{hour:02d}:{minute:02d}:00"

                    if point_index < len(trend_prices):
                        price = trend_prices[point_index]

                        # Add small intraday fluctuations
                        random.seed(hash(f"{symbol}_{current_date.strftime('%Y%m%d')}_{hour}_{minute}") % 2147483647)

                        if is_index:
                            intraday_range = price * 0.002  # ±0.2% intraday for indexes
                        else:
                            intraday_range = price * 0.005  # ±0.5% intraday for stocks

                        intraday_fluctuation = random.uniform(-intraday_range, intraday_range)
                        final_price = price + intraday_fluctuation

                        data.append({
                            'TradingDate': current_date.strftime('%d/%m/%Y'),
                            'Time': time_str,
                            'ClosePrice': float(round(final_price, 2))
                        })

                    point_index += 1

        current_date += timedelta(days=1)

    return data

async def fetch_mock_daily_data(symbol: str, start_date: datetime, end_date: datetime, is_index: bool):
    """Generate realistic daily data with smooth trends"""
    print(f"🎭 Generating mock daily data for {symbol} (index: {is_index})")

    base_price = get_base_price(symbol)
    current_realtime_price = get_current_realtime_price(symbol)

    if not base_price:
        print(f"❌ No base price for {symbol}")
        return []

    data = []

    # Calculate total trading days
    trading_days = []
    temp_date = start_date
    while temp_date <= end_date:
        if temp_date.weekday() < 5:  # Skip weekends
            trading_days.append(temp_date)
        temp_date += timedelta(days=1)

    total_days = len(trading_days)

    # Generate smooth trend prices
    trend_prices = generate_smooth_trend(base_price, current_realtime_price, total_days, is_index)

    for day_index, current_date in enumerate(trading_days):
        if day_index < len(trend_prices):
            price = trend_prices[day_index]

            # Add small daily fluctuations
            random.seed(hash(f"{symbol}_{current_date.strftime('%Y%m%d')}") % 2147483647)

            if is_index:
                daily_range = price * 0.008  # ±0.8% daily for indexes
            else:
                daily_range = price * 0.02   # ±2% daily for stocks

            daily_fluctuation = random.uniform(-daily_range, daily_range)
            final_price = price + daily_fluctuation

            if is_index:
                data.append({
                    'TradingDate': current_date.strftime('%d/%m/%Y'),
                    'IndexValue': float(round(final_price, 2))
                })
            else:
                data.append({
                    'TradingDate': current_date.strftime('%d/%m/%Y'),
                    'ClosePrice': float(round(final_price, 2))
                })

    return data

async def fetch_stock_prices(symbol: str, start_date: datetime, end_date: datetime, time_range: str):
    """Fetch fresh mock stock prices based on current Redis prices"""
    is_index = symbol in [index[0] for index in indexes]

    print(f"🎭 Generating fresh mock data for {symbol} (range: {time_range}) based on current Redis price")

    if time_range in ['1d', '1w']:
        all_data = await fetch_mock_intraday_data(symbol, start_date, end_date, time_range)
    else:
        all_data = await fetch_mock_daily_data(symbol, start_date, end_date, is_index)

    # Sort by date
    all_data = sorted(all_data, key=lambda x: datetime.strptime(x['TradingDate'], '%d/%m/%Y'))

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
    """Clear Redis current prices (no historical data cache)"""
    try:
        # Only clear current price keys, not all Redis data
        stock_keys = redis_client.keys("current_stock_price:*")
        index_keys = redis_client.keys("current_index_price:*")
        all_keys = stock_keys + index_keys

        if all_keys:
            redis_client.delete(*all_keys)

        return {"message": "Current price cache cleared successfully", "keys_deleted": len(all_keys)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to clear cache: {str(e)}")

@app.delete("/cache/symbol/{symbol}")
async def clear_symbol_cache(symbol: str):
    """Clear current price for specific symbol"""
    try:
        stock_key = f"current_stock_price:{symbol}"
        index_key = f"current_index_price:{symbol}"

        keys_deleted = 0
        if redis_client.exists(stock_key):
            redis_client.delete(stock_key)
            keys_deleted += 1
        if redis_client.exists(index_key):
            redis_client.delete(index_key)
            keys_deleted += 1

        return {"message": f"Current price cleared for symbol {symbol}", "keys_deleted": keys_deleted}
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
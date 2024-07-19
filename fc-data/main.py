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

# stocks, indexes = get_symbols()

class StreamManager:
    def __init__(self):
        self.stock_stream = None
        self.index_stream = None
        self.main_view_subscribers = set()
        self.stock_subscribers = defaultdict(set)
        self.index_subscribers = defaultdict(set)
        self.message_queue = Queue()
        self.should_stop = threading.Event()
        self.processing_thread = threading.Thread(target=self._process_messages)
        self.processing_thread.start()
        self.lock = threading.Lock()
        self.websocket_queues = {}
        
        self.stocks, self.indexes = get_symbols()
        self.all_stock_data = {}
        self.all_index_data = {}
        self.stock_symbols = set(symbol for symbol, _, _ in self.stocks)
        self.index_symbols = set(index for index, _ in self.indexes)
        self.last_categorized_data = None
        self.main_view_update_needed = False
        self.websocket_subscriptions = defaultdict(set)
        self.main_view_stocks = set()
        self.last_sent_categorized_data = {}
        self.current_stock_subscription = None
        self.current_index_subscription = None


    def start_streams(self):
        self.stock_stream = MarketDataStream(config, client)
        self.index_stream = MarketDataStream(config, client)
        self.stock_stream.start(on_stock_message, on_error, "X:ALL")
        self.index_stream.start(on_index_message, on_error, "MI:ALL")

    def stop_streams(self):
        if self.stock_stream:
            self.stock_stream.swith_channel("X:NONE")
        if self.index_stream:
            self.index_stream.swith_channel("MI:NONE")
        time.sleep(1)
        self.stock_stream = None
        self.index_stream = None

    def _process_messages(self):
        while not self.should_stop.is_set():
            try:
                message_type, data = self.message_queue.get(timeout=0.01)
                if message_type == 'stock':
                    asyncio.run(self.broadcast_stock_update(data['symbol'], data['data']))
                elif message_type == 'index':
                    asyncio.run(self.broadcast_index_update(data['index'], data['data']))
                
                if self.main_view_update_needed:
                    asyncio.run(self.broadcast_main_view_update())
            except Empty:
                continue
            except Exception as e:
                print(f"Error processing message: {e}")

    def stop(self):
        self.should_stop.set()
        self.processing_thread.join()
        self.stop_streams()

    async def subscribe_main_view(self, websocket: WebSocket):

        await self.unsubscribe_all(websocket)
        if self.stock_stream or self.index_stream:
            self.stop_streams()
        self.start_streams()
        self.main_view_subscribers.add(websocket)
        self.websocket_subscriptions[websocket].add('main_view')
        await self.update_main_view_channels()
        
        await websocket.send_json({"type": "main_view_update", "categorized_stocks": self.categorize_stocks()})
        for index, data in self.all_index_data.items():
            await websocket.send_json({"type": "index_update", "index": index, "data": data})
        print(f"Subscribed to main view. Total subscribers: {len(self.main_view_subscribers)}")


    async def subscribe_stock(self, symbol: str, websocket: WebSocket):
        if symbol not in self.stock_symbols:
            return
        await self.unsubscribe_all(websocket)
        self.current_stock_subscription = symbol
        self.stock_subscribers[symbol] = {websocket}
        self.websocket_subscriptions[websocket].add(f'stock:{symbol}')
        await self._update_stock_stream()
        if symbol in self.all_stock_data:
            await websocket.send_json({"type": "stock_update", "symbol": symbol, "data": self.all_stock_data[symbol]})
        print(f"Subscribed to stock: {symbol}. Total subscribers: {len(self.stock_subscribers[symbol])}")

    async def subscribe_index(self, index: str, websocket: WebSocket):
        if index not in self.index_symbols:
            return
        await self.unsubscribe_all(websocket)
        self.current_index_subscription = index
        self.index_subscribers[index] = {websocket}
        self.websocket_subscriptions[websocket].add(f'index:{index}')
        await self._update_index_stream()
        if index in self.all_index_data:
            await websocket.send_json({"type": "index_update", "index": index, "data": self.all_index_data[index]})
        print(f"Subscribed to index: {index}. Total subscribers: {len(self.index_subscribers[index])}")

    async def update_main_view_channels(self):
        if not self.last_categorized_data:
            return
        new_main_view_stocks = set()
        for category in ['top_increase', 'top_decrease', 'top_volume']:
            new_main_view_stocks.update(stock['symbol'] for stock in self.last_categorized_data[category])
        
        if new_main_view_stocks != self.main_view_stocks:
            self.main_view_stocks = new_main_view_stocks
            await self._update_stock_stream()

    async def _update_stock_stream(self):
        all_symbols = set()
        if self.main_view_subscribers:
            all_symbols.update(self.main_view_stocks)
        if self.current_stock_subscription:
            all_symbols.add(self.current_stock_subscription)
        channel = f"X:{'-'.join(all_symbols)}" if all_symbols else "X:NONE"
        print(f"Updating stock stream: {channel}")
        self.stock_stream.swith_channel(channel)

    async def _update_index_stream(self):
        channel = f"MI:{self.current_index_subscription}" if self.current_index_subscription else "MI:NONE"
        print(f"Updating index stream: {channel}")
        self.index_stream.swith_channel(channel)

    def update_stock_data(self, symbol: str, data: dict):
        if symbol not in self.stock_symbols:
            return None
        if self.all_stock_data.get(symbol) != data:
            self.all_stock_data[symbol] = data
            new_categorized_data = self.categorize_stocks()
            if new_categorized_data != self.last_categorized_data:
                self.last_categorized_data = new_categorized_data
                self.main_view_update_needed = True
            return True
        return False

    def update_index_data(self, index: str, data: dict):
        if index not in self.index_symbols:
            return False
        if self.all_index_data.get(index) != data:
            self.all_index_data[index] = data
            return True
        return False

    def categorize_stocks(self):
        stocks = []
        for symbol, name, market in self.stocks:
            if symbol in self.all_stock_data:
                stock_data = self.all_stock_data[symbol]
                if stock_data.get('RatioChange', 0) != -100.0:
                    stocks.append({
                        "symbol": symbol,
                        "name": name,
                        "market": market,
                        **stock_data  
                    })
        
        top_increase = sorted(stocks, key=lambda x: x.get('RatioChange', 0), reverse=True)[:3]
        top_decrease = sorted(stocks, key=lambda x: x.get('RatioChange', 0))[:3]
        top_volume = sorted(stocks, key=lambda x: x.get('TotalVol', 0), reverse=True)[:3]
        
        return {
            "top_increase": top_increase,
            "top_decrease": top_decrease,
            "top_volume": top_volume
        }

    async def broadcast_stock_update(self, symbol: str, data: dict):
        with self.lock:
            if self.update_stock_data(symbol, data):
                if symbol in self.stock_subscribers:
                    message = {"type": "stock_update", "symbol": symbol, "data": data}
                    await self._broadcast(self.stock_subscribers[symbol], message)
                if symbol in self.main_view_stocks or self.main_view_subscribers:
                    await self.broadcast_main_view_update()

    async def broadcast_index_update(self, index: str, data: dict):
        with self.lock:
            if self.update_index_data(index, data):
                message = {"type": "index_update", "index": index, "data": data}
                if self.main_view_subscribers:
                    await self._broadcast(self.main_view_subscribers, message)
                if index in self.index_subscribers:
                    await self._broadcast(self.index_subscribers[index], message)

    async def broadcast_main_view_update(self):
        if self.main_view_subscribers:
            categorized_data = self.categorize_stocks()
            message = {"type": "main_view_update", "categorized_stocks": categorized_data}
            if categorized_data != self.last_categorized_data:
                await self._broadcast(self.main_view_subscribers, message)
                self.last_categorized_data = categorized_data
            
            # Send individual stock updates for all stocks in the main view
            for category in categorized_data.values():
                for stock in category:
                    stock_message = {"type": "stock_update", "symbol": stock['symbol'], "data": self.all_stock_data[stock['symbol']]}
                    await self._broadcast(self.main_view_subscribers, stock_message)
            
            # Send all index updates
            for index, data in self.all_index_data.items():
                index_message = {"type": "index_update", "index": index, "data": data}
                await self._broadcast(self.main_view_subscribers, index_message)

    async def _broadcast(self, subscribers, message):
        for websocket in list(subscribers):
            try:
                await asyncio.shield(websocket.send_json(message))
            except Exception as e:
                print(f"Error sending message to WebSocket: {e}")
                await self.unsubscribe_all(websocket)

    async def unsubscribe_all(self, websocket: WebSocket):
        subscriptions = self.websocket_subscriptions.pop(websocket, set())
        for subscription in subscriptions:
            if subscription == 'main_view':
                self.main_view_subscribers.discard(websocket)
            elif subscription.startswith('stock:'):
                _, symbol = subscription.split(':')
                self.stock_subscribers[symbol].discard(websocket)
                if len(self.stock_subscribers[symbol]) == 0:
                    del self.stock_subscribers[symbol]
            elif subscription.startswith('index:'):
                _, index = subscription.split(':')
                self.index_subscribers[index].discard(websocket)
                if len(self.index_subscribers[index]) == 0:
                    del self.index_subscribers[index]
        
        self.current_stock_subscription = None
        self.current_index_subscription = None
        await self._update_stock_stream()
        await self._update_index_stream()
        print(f"Unsubscribed from all for websocket")

    def get_categorized_stocks(self, category: str, limit: int = 30):
        stocks = []
        for symbol, name, market in self.stocks:
            if symbol in self.all_stock_data:
                stock_data = self.all_stock_data[symbol]
                if stock_data.get('RatioChange', 0) != -100.0:
                    stocks.append({
                        "symbol": symbol,
                        "name": name,
                        "market": market,
                        **stock_data
                    })
        
        if category == 'top_increase':
            return sorted(stocks, key=lambda x: x.get('RatioChange', 0), reverse=True)[:limit]
        elif category == 'top_decrease':
            return sorted(stocks, key=lambda x: x.get('RatioChange', 0))[:limit]
        elif category == 'top_volume':
            return sorted(stocks, key=lambda x: x.get('TotalVol', 0), reverse=True)[:limit]
        else:
            raise ValueError("Invalid category")

    def search_stocks(self, query: str):
        results = []
        for symbol, name, market in self.stocks:
            if query.lower() in symbol.lower() or query.lower() in name.lower():
                stock_data = self.all_stock_data.get(symbol, {})
                results.append({
                    "symbol": symbol,
                    "name": name,
                    "market": market,
                    **stock_data
                })
        return results

    async def subscribe_category(self, category: str, websocket: WebSocket):
        self.websocket_subscriptions[websocket].add(f'category:{category}')
        stocks = self.get_categorized_stocks(category)
        await websocket.send_json({"type": "category_update", "category": category, "stocks": stocks})
            
stream_manager = StreamManager()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    stream_manager.start_streams()
    yield
    # Shutdown
    stream_manager.stop()

app = FastAPI(lifespan=lifespan)

def on_stock_message(message):
    try:
        data = json.loads(message['Content'])
        symbol = data['Symbol']
        if symbol in stream_manager.stock_symbols:
            stream_manager.message_queue.put(('stock', {'symbol': symbol, 'data': data}))
    except json.JSONDecodeError:
        print(f"Failed to decode stock message: {message}")
    except Exception as e:
        print(f"Error in on_stock_message: {e}")

def on_index_message(message):
    try:
        data = json.loads(message['Content'])
        index_id = data['IndexId']
        if index_id in stream_manager.index_symbols:
            stream_manager.message_queue.put(('index', {'index': index_id, 'data': data}))
    except json.JSONDecodeError:
        print(f"Failed to decode index message: {message}")
    except Exception as e:
        print(f"Error in on_index_message: {e}")

def on_error(error):
    print(f"Streaming error occurred: {error}")

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    print("WebSocket connection accepted")
    try:
        while True:
            try:
                data = await websocket.receive_json()
                print(f"Received WebSocket message: {data}")
                if data['type'] == 'subscribe':
                    if data['category'] == 'main_view':
                        await stream_manager.subscribe_main_view(websocket)
                    elif data['category'] == 'stock':
                        await stream_manager.subscribe_stock(data['symbol'], websocket)
                    elif data['category'] == 'index':
                        await stream_manager.subscribe_index(data['symbol'], websocket)
                    elif data['category'] in ['top_increase', 'top_decrease', 'top_volume']:
                        await stream_manager.subscribe_category(data['category'], websocket)
                elif data['type'] == 'unsubscribe':
                    await stream_manager.unsubscribe_all(websocket)
            except WebSocketDisconnect:
                print("WebSocket disconnected")
                break
            except json.JSONDecodeError:
                print("Received invalid JSON")
            except Exception as e:
                print(f"Error in websocket communication: {e}")
                if websocket.client_state == WebSocketState.DISCONNECTED:
                    break
    finally:
        print("Cleaning up WebSocket connection")
        await stream_manager.unsubscribe_all(websocket)

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

    while response['status'] != 'Success' and range =='1d':
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

    return [{'TradingDate': item['TradingDate'], 'Time': item['Time'], 'ClosePrice': item['Close']} for item in response['data']]

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

    if is_index:
        return [{'TradingDate': item['TradingDate'], 'IndexValue': item['IndexValue']} for item in response['data']]
    else:
        return [{'TradingDate': item['TradingDate'], 'ClosePrice': item['ClosePrice']} for item in response['data']]

async def fetch_stock_prices(symbol: str, start_date: datetime, end_date: datetime, range: str):
    cache_key = get_cache_key(symbol, start_date, end_date)
    cache_data = redis_client.get(cache_key)

    if cache_data:
        return json.loads(cache_data)

    is_index = symbol in [index[0] for index in stream_manager.indexes]
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

    redis_client.setex(cache_key, 60*60*24, json.dumps(all_data))

    return all_data



@app.get("/api/main_market")
async def get_main_market():
    try:
        return {
            "top_increase": stream_manager.get_categorized_stocks("top_increase", 3),
            "top_decrease": stream_manager.get_categorized_stocks("top_decrease", 3),
            "top_volume": stream_manager.get_categorized_stocks("top_volume", 3)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/category/{category}")
async def get_category_stocks(category: str, limit: int = 30):
    try:
        return stream_manager.get_categorized_stocks(category, limit)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/search")
async def search_stocks(query: str = ""):
    try:
        return stream_manager.search_stocks(query)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/stock/{symbol}")
async def get_stock_details(symbol: str, range: str = "1d"):
    try:
        is_index = symbol in [index[0] for index in stream_manager.indexes]
        
        if is_index:
            info = next((index for index in stream_manager.indexes if index[0] == symbol), None)
            if not info:
                raise HTTPException(status_code=404, detail="Index not found")
            name = symbol
            market = info[1]
            current_data = stream_manager.all_index_data.get(symbol, {})
        else:
            info = next((stock for stock in stream_manager.stocks if stock[0] == symbol), None)
            if not info:
                raise HTTPException(status_code=404, detail="Stock not found")
            name = info[1]
            market = info[2]
            current_data = stream_manager.all_stock_data.get(symbol, {})

        start_date, end_date = get_date_range(range)
        historical_data = await fetch_stock_prices(symbol, start_date, end_date, range)

        return {
            "symbol": symbol,
            "name": name,
            "market": market,
            "current_data": current_data,
            "historical_data": historical_data
        }
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
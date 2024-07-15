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

class StreamManager:
    def __init__(self):
        self.stock_stream = MarketDataStream(config, client)
        self.index_stream = MarketDataStream(config, client)
        self.main_view_subscribers = set()
        self.stock_subscribers = defaultdict(set)
        self.index_subscribers = defaultdict(set)
        self.message_queue = Queue()
        self.should_stop = threading.Event()
        self.processing_thread = threading.Thread(target=self._process_messages)
        self.processing_thread.start()

    def _process_messages(self):
        while not self.should_stop.is_set():
            try:
                message_type, data = self.message_queue.get(timeout=1)
                if message_type == 'stock':
                    asyncio.run(self.broadcast_stock_update(data['symbol'], data['data']))
                elif message_type == 'index':
                    asyncio.run(self.broadcast_index_update(data['index'], data['data']))
            except Empty:
                continue
            except Exception as e:
                print(f"Error processing message: {e}")

    def stop(self):
        self.should_stop.set()
        self.processing_thread.join()

    async def subscribe_main_view(self, websocket: WebSocket):
        self.main_view_subscribers.add(websocket)
        if len(self.main_view_subscribers) == 1:
            self.stock_stream.swith_channel("X:ALL")
            self.index_stream.swith_channel("MI:ALL")
        print(f"Subscribed to main view. Total subscribers: {len(self.main_view_subscribers)}")

    async def unsubscribe_main_view(self, websocket: WebSocket):
        self.main_view_subscribers.discard(websocket)
        if len(self.main_view_subscribers) == 0:
            self._update_stream_channels()
        print(f"Unsubscribed from main view. Total subscribers: {len(self.main_view_subscribers)}")

    async def subscribe_stock(self, symbol: str, websocket: WebSocket):
        self.stock_subscribers[symbol].add(websocket)
        self._update_stock_stream()
        print(f"Subscribed to stock: {symbol}. Total subscribers: {len(self.stock_subscribers[symbol])}")

    async def unsubscribe_stock(self, symbol: str, websocket: WebSocket):
        self.stock_subscribers[symbol].discard(websocket)
        if len(self.stock_subscribers[symbol]) == 0:
            del self.stock_subscribers[symbol]
        self._update_stock_stream()
        print(f"Unsubscribed from stock: {symbol}")

    async def subscribe_index(self, index: str, websocket: WebSocket):
        self.index_subscribers[index].add(websocket)
        self._update_index_stream()
        print(f"Subscribed to index: {index}. Total subscribers: {len(self.index_subscribers[index])}")

    async def unsubscribe_index(self, index: str, websocket: WebSocket):
        self.index_subscribers[index].discard(websocket)
        if len(self.index_subscribers[index]) == 0:
            del self.index_subscribers[index]
        self._update_index_stream()
        print(f"Unsubscribed from index: {index}")

    def _update_stock_stream(self):
        symbols = list(self.stock_subscribers.keys())
        channel = f"X:{'-'.join(symbols)}" if symbols else "X:NONE"
        print(f"Updating stock stream: {channel}")
        self.stock_stream.swith_channel(channel)

    def _update_index_stream(self):
        indices = list(self.index_subscribers.keys())
        channel = f"MI:{'-'.join(indices)}" if indices else "MI:NONE"
        print(f"Updating index stream: {channel}")
        self.index_stream.swith_channel(channel)

    def _update_stream_channels(self):
        self._update_stock_stream()
        self._update_index_stream()

    async def broadcast_stock_update(self, symbol: str, data: dict):
        message = {"type": "stock_update", "symbol": symbol, "data": data}
        if self.main_view_subscribers or symbol in self.stock_subscribers:
            await self._broadcast(self.main_view_subscribers, message)
            await self._broadcast(self.stock_subscribers[symbol], message)

    async def broadcast_index_update(self, index: str, data: dict):
        message = {"type": "index_update", "index": index, "data": data}
        if self.main_view_subscribers or index in self.index_subscribers:
            await self._broadcast(self.main_view_subscribers, message)
            await self._broadcast(self.index_subscribers[index], message)

    async def _broadcast(self, subscribers, message):
        for websocket in list(subscribers):
            try:
                await websocket.send_json(message)
            except Exception as e:
                print(f"Error sending message to WebSocket: {e}")
                subscribers.discard(websocket)

stream_manager = StreamManager()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    stream_manager.stock_stream.start(on_stock_message, on_error, "X:ALL")
    stream_manager.index_stream.start(on_index_message, on_error, "MI:ALL")
    yield
    # Shutdown
    stream_manager.stock_stream.stop()
    stream_manager.index_stream.stop()
    stream_manager.stop()

app = FastAPI(lifespan=lifespan)

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

    redis_client.setex(cache_key, 60*60*24, json.dumps(all_data))

    return all_data

@app.get("/historical_prices/")
async def get_stock_prices(request: StockPriceRequest):
    try:
        start_date, end_date = get_date_range(request.range)
        data = await fetch_stock_prices(request.symbol, start_date, end_date, request.range)
        if request.symbol in [index[0] for index in indexes]:
            index_info = next((index for index in indexes if index[0] == request.symbol), None)
            name = request.symbol
            market = index_info[1]
        else:
            stock_info = next((stock for stock in stocks if stock[0] == request.symbol), None)
            name = stock_info[1]
            market = stock_info[2]
        return {"symbol": request.symbol, "name": name, "market": market, "data": data}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@app.get("/market/")
def get_market():
    return {"stocks": stocks, "indexes": indexes}

def on_stock_message(message):
    try:
        data = json.loads(message['Content'])
        symbol = data['Symbol']
        print(f"Received stock update for {symbol}")
        stream_manager.message_queue.put(('stock', {'symbol': symbol, 'data': data}))
    except json.JSONDecodeError:
        print(f"Failed to decode stock message: {message}")
    except Exception as e:
        print(f"Error in on_stock_message: {e}")

def on_index_message(message):
    try:
        data = json.loads(message['Content'])
        index_id = data['IndexId']
        print(f"Received index update for {index_id}")
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
                elif data['type'] == 'unsubscribe':
                    if data['category'] == 'main_view':
                        await stream_manager.unsubscribe_main_view(websocket)
                    elif data['category'] == 'stock':
                        await stream_manager.unsubscribe_stock(data['symbol'], websocket)
                    elif data['category'] == 'index':
                        await stream_manager.unsubscribe_index(data['symbol'], websocket)

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
        await stream_manager.unsubscribe_main_view(websocket)
        for symbol in list(stream_manager.stock_subscribers.keys()):
            await stream_manager.unsubscribe_stock(symbol, websocket)
        for index in list(stream_manager.index_subscribers.keys()):
            await stream_manager.unsubscribe_index(index, websocket)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
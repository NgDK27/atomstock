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
        
        self.stocks, self.indexes = get_symbols()
        self.all_stock_data = {symbol: {} for symbol, _, _ in self.stocks}
        self.all_index_data = {index: {} for index, _ in self.indexes}
        self.stock_symbols = set(symbol for symbol, _, _ in self.stocks)
        self.index_symbols = set(index for index, _ in self.indexes)
        self.last_categorized_data = None

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
        # Allow some time for the streams to process the channel switch
        time.sleep(1)
        self.stock_stream = None
        self.index_stream = None

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
        self.stop_streams()

    async def subscribe_main_view(self, websocket: WebSocket):
        self.main_view_subscribers.add(websocket)
        if len(self.main_view_subscribers) == 1:
            self.stock_stream.swith_channel("X:ALL")
            self.index_stream.swith_channel("MI:ALL")
        await self.send_baseline_data(websocket)
        if self.last_categorized_data:
            await websocket.send_json({"type": "main_view_update", "categorized_stocks": self.last_categorized_data})
        print(f"Subscribed to main view. Total subscribers: {len(self.main_view_subscribers)}")

    async def send_baseline_data(self, websocket: WebSocket):
        baseline_data = {
            "type": "baseline_data",
            "stocks": [{"symbol": symbol, "name": name, "market": market} for symbol, name, market in self.stocks],
            "indexes": [{"symbol": symbol, "market": market} for symbol, market in self.indexes]
        }
        await websocket.send_json(baseline_data)

    async def unsubscribe_main_view(self, websocket: WebSocket):
        self.main_view_subscribers.discard(websocket)
        if len(self.main_view_subscribers) == 0:
            self._update_stream_channels()
        print(f"Unsubscribed from main view. Total subscribers: {len(self.main_view_subscribers)}")

    async def subscribe_stock(self, symbol: str, websocket: WebSocket):
        if symbol not in self.stock_symbols:
            return
        self.stock_subscribers[symbol].add(websocket)
        self._update_stock_stream()
        if symbol in self.all_stock_data and self.all_stock_data[symbol]:
            await websocket.send_json({"type": "stock_update", "symbol": symbol, "data": self.all_stock_data[symbol]})
        print(f"Subscribed to stock: {symbol}. Total subscribers: {len(self.stock_subscribers[symbol])}")

    async def unsubscribe_stock(self, symbol: str, websocket: WebSocket):
        self.stock_subscribers[symbol].discard(websocket)
        if len(self.stock_subscribers[symbol]) == 0:
            del self.stock_subscribers[symbol]
        self._update_stock_stream()
        print(f"Unsubscribed from stock: {symbol}")

    async def subscribe_index(self, index: str, websocket: WebSocket):
        if index not in self.index_symbols:
            return
        self.index_subscribers[index].add(websocket)
        self._update_index_stream()
        if index in self.all_index_data and self.all_index_data[index]:
            await websocket.send_json({"type": "index_update", "index": index, "data": self.all_index_data[index]})
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

    def update_stock_data(self, symbol: str, data: dict):
        if symbol not in self.stock_symbols:
            return None
        self.all_stock_data[symbol] = data
        self.last_categorized_data = self.categorize_stocks()
        return self.last_categorized_data

    def update_index_data(self, index: str, data: dict):
        if index not in self.index_symbols:
            return
        self.all_index_data[index] = data

    def categorize_stocks(self):
        stocks = [
            {**data, "symbol": symbol, "name": name, "market": market}
            for (symbol, name, market), data in zip(self.stocks, self.all_stock_data.values())
            if data  # Only include stocks with actual data
        ]
        
        top_increase = sorted(stocks, key=lambda x: x.get('RatioChange', 0), reverse=True)[:10]
        top_decrease = sorted(stocks, key=lambda x: x.get('RatioChange', 0))[:10]
        top_volume = sorted(stocks, key=lambda x: x.get('TotalVol', 0), reverse=True)[:10]
        
        return {
            "top_increase": top_increase,
            "top_decrease": top_decrease,
            "top_volume": top_volume
        }

    async def broadcast_stock_update(self, symbol: str, data: dict):
        categorized_data = self.update_stock_data(symbol, data)
        if categorized_data and self.main_view_subscribers:
            message = {"type": "main_view_update", "categorized_stocks": categorized_data}
            await self._broadcast(self.main_view_subscribers, message)
        
        if symbol in self.stock_subscribers:
            message = {"type": "stock_update", "symbol": symbol, "data": data}
            await self._broadcast(self.stock_subscribers[symbol], message)

    async def broadcast_index_update(self, index: str, data: dict):
        self.update_index_data(index, data)
        if self.main_view_subscribers:
            message = {"type": "index_update", "index": index, "data": data}
            await self._broadcast(self.main_view_subscribers, message)
        
        if index in self.index_subscribers:
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
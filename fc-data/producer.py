import asyncio
from ssi_fc_data import fc_md_client, model
from ssi_fc_data.fc_md_stream import MarketDataStream
from confluent_kafka import Producer
from confluent_kafka.admin import AdminClient, NewTopic
import json
import config
from dotenv import load_dotenv
from pathlib import Path
import os
import psycopg2
import logging
import socket

# Project setup
project_root = Path(__file__).parent.parent.parent
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

# Database configuration
DB_HOST = os.getenv('HOST') or 'localhost'
DB_NAME = os.getenv('DB_NAME') or 'capstone'
DB_USER = os.getenv('USER') or 'quando'
DB_PASSWORD = os.getenv('PASSWORD') or '808225'

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


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

# Load environment variables
load_dotenv()

# Get symbols
stocks, indexes = get_symbols()

# Kafka configuration
KAFKA_HOST = os.getenv('KAFKA_HOST') or '192.168.25.229'
KAFKA_PORT = os.getenv('KAFKA_PORT') or '9092'

kafka_config = {
    'bootstrap.servers': f"{KAFKA_HOST}:{KAFKA_PORT}",
}

producer = Producer(kafka_config)


# Initialize the SSI client
client = fc_md_client.MarketDataClient(config)

def delivery_report(err, msg):
    if err is not None:
        logger.error(f'Message delivery failed: {err}')
    else:
        topic = msg.topic()
        logger.info(f"Message delivered to topic {topic}")

def on_stock_message(message):
    try:
        data = json.loads(message['Content'])
        symbol = data['Symbol']
        topic = f'stock-{symbol}'
        
        
        formatted_data = {
            "Symbol": data['Symbol'],
            "Price": float(data['LastPrice']),
            "Change": float(data['Change']),
            "RatioChange": float(data['RatioChange']),
            "Volume": float(data['TotalVol'])
        }
        
        producer.produce(topic, json.dumps(formatted_data).encode('utf-8'), callback=delivery_report)
        producer.poll(0)
    except Exception as e:
        logger.error(f"Error in on_stock_message: {e}")

def on_index_message(message):
    try:
        data = json.loads(message['Content'])
        index_id = data['IndexId']
        topic = f'index-{index_id}'
        
       
        formatted_data = {
            "IndexId": data['IndexId'],
            "IndexValue": float(data['IndexValue']),
            "Change": float(data['Change']),
            "RatioChange": float(data['RatioChange']),
            "TotalTrade": int(data['TotalTrade']),
            "TotalQtty": int(data['TotalQtty']),
            "TotalValue": float(data['TotalValue'])
        }
        
        producer.produce(topic, json.dumps(formatted_data).encode('utf-8'), callback=delivery_report)
        producer.poll(0)
    except Exception as e:
        logger.error(f"Error in on_index_message: {e}")

def on_error(error):
    logger.error(f"Streaming error occurred: {error}")

async def main():
    stock_stream = MarketDataStream(config, client)
    index_stream = MarketDataStream(config, client)

    stock_symbols = "-".join([symbol for symbol, _, _ in stocks])
    index_symbols = "-".join([symbol for symbol, _ in indexes])

    stock_stream.start(on_stock_message, on_error, f"X:{stock_symbols}")
    index_stream.start(on_index_message, on_error, f"MI:{index_symbols}")

    while True:
        producer.poll()
        await asyncio.sleep(1)

if __name__ == "__main__":
    asyncio.run(main())
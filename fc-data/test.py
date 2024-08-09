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
import config
import logging

project_root = Path(__file__).parent.parent.parent
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

DB_HOST = os.getenv('HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('USER')
DB_PASSWORD = os.getenv('PASSWORD')

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

load_dotenv()

stocks, indexes = get_symbols()

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Initialize Kafka producer
kafka_config = {
    'bootstrap.servers': f"{os.getenv('KAFKA_HOST')}:{os.getenv('KAFKA_PORT')}",
}

producer = Producer(kafka_config)

# Initialize the SSI client
client = fc_md_client.MarketDataClient(config)

# def create_topics(topic_names):
#     admin_client = AdminClient({'bootstrap.servers': f"{os.getenv('KAFKA_HOST')}:{os.getenv('KAFKA_PORT')}"})
#     new_topics = [NewTopic(topic, num_partitions=1, replication_factor=1) for topic in topic_names]
#     fs = admin_client.create_topics(new_topics)
#     for topic, f in fs.items():
#         try:
#             f.result()  # The result itself is None
#             print(f"Topic {topic} created")
#         except Exception as e:
#             print(f"Failed to create topic {topic}: {e}")

# # Call this function before starting to produce messages
# create_topics([f'stock-{symbol}' for symbol, _, _ in stocks] + [f'index-{symbol}' for symbol, _ in indexes])

def delivery_report(err, msg):
    if err is not None:
        logger.error(f'Message delivery failed: {err}')
    else:
        topic = msg.topic()
        value = json.loads(msg.value().decode('utf-8'))
        logger.info(f"Message delivered to topic {topic}")

def on_stock_message(message):
    try:
        data = json.loads(message['Content'])
        symbol = data['Symbol']
        topic = f'stock-{symbol}'
        
        producer.produce(topic, json.dumps(data).encode('utf-8'), callback=delivery_report)
        producer.poll(0)
    except Exception as e:
        print(f"Error in on_stock_message: {e}")

def on_index_message(message):
    try:
        data = json.loads(message['Content'])
        index_id = data['IndexId']
        topic = f'stock-{index_id}'

        producer.produce(topic, json.dumps(data).encode('utf-8'), callback=delivery_report)
        producer.poll(0)
    except Exception as e:
        print(f"Error in on_index_message: {e}")

def on_error(error):
    print(f"Streaming error occurred: {error}")

async def main():

    stock_stream = MarketDataStream(config, client)
    index_stream = MarketDataStream(config, client)

    stock_symbols = "-".join([symbol for symbol, _, _ in stocks])
    index_symbols = "-".join([symbol for symbol, _ in indexes])

    stock_stream.start(on_stock_message, on_error, f"X:{stock_symbols}")
    index_stream.start(on_index_message, on_error, f"MI:{index_symbols}")

    while True:
        producer.poll(0.1)
        await asyncio.sleep(1)

if __name__ == "__main__":
    asyncio.run(main())
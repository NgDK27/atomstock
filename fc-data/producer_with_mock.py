import asyncio
import json
import random
import time
from confluent_kafka import Producer
import logging
from datetime import datetime
import psycopg2
import os
from dotenv import load_dotenv
from pathlib import Path

# Import centralized symbol configuration
from symbols_config import get_all_symbols, get_symbol_info

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

        # Get configured symbols for comparison
        config_stocks, config_indexes = get_all_symbols()
        config_stock_symbols = [s[0] for s in config_stocks]
        config_index_symbols = [i[0] for i in config_indexes]

        try:
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
                logger.info(f"Using {len(stock_symbols)} stocks from database")
            else:
                stock_symbols = config_stocks
                logger.info(f"Using {len(stock_symbols)} stocks from configuration")

            if db_indexes:
                index_symbols = [(row[0], row[1]) for row in db_indexes]
                logger.info(f"Using {len(index_symbols)} indexes from database")
            else:
                index_symbols = config_indexes
                logger.info(f"Using {len(index_symbols)} indexes from configuration")

        except Exception as query_error:
            logger.error(f"Error querying database: {query_error}")
            # Use configured symbols as fallback
            stock_symbols, index_symbols = get_all_symbols()
            logger.info(f"Using configured symbols as fallback: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

        finally:
            cursor.close()
            conn.close()

    except Exception as error:
        logger.error(f"Error while connecting to database: {error}")
        # Use configured symbols as fallback
        stock_symbols, index_symbols = get_all_symbols()
        logger.info(f"Using configured symbols: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

    logger.info(f"Final symbol count: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")
    return stock_symbols, index_symbols

# Kafka configuration
KAFKA_HOST = os.getenv('KAFKA_HOST') or '10.147.20.102'
KAFKA_PORT = os.getenv('KAFKA_PORT') or '9092'

kafka_config = {
    'bootstrap.servers': f"{KAFKA_HOST}:{KAFKA_PORT}",
}

producer = Producer(kafka_config)

def delivery_report(err, msg):
    if err is not None:
        logger.error(f'Message delivery failed: {err}')
    else:
        topic = msg.topic()
        logger.debug(f"Message delivered to topic {topic}")

def generate_mock_stock_data(symbol, base_price=100000):
    """Generate realistic mock stock data"""
    # Simulate price movements
    change_percent = random.uniform(-0.05, 0.05)  # ±5% change
    current_price = base_price * (1 + change_percent)
    change = current_price - base_price
    ratio_change = change_percent * 100
    volume = random.randint(10000, 1000000)

    return {
        "Symbol": symbol,
        "Price": round(current_price, 2),
        "Change": round(change, 2),
        "RatioChange": round(ratio_change, 2),
        "Volume": volume,
        "Timestamp": datetime.now().isoformat()
    }

def generate_mock_index_data(index_id, base_value=1000):
    """Generate realistic mock index data"""
    change_percent = random.uniform(-0.03, 0.03)  # ±3% change
    current_value = base_value * (1 + change_percent)
    change = current_value - base_value
    ratio_change = change_percent * 100

    return {
        "IndexId": index_id,
        "IndexValue": round(current_value, 2),
        "Change": round(change, 2),
        "RatioChange": round(ratio_change, 2),
        "TotalTrade": random.randint(1000, 10000),
        "TotalQtty": random.randint(1000000, 10000000),
        "TotalValue": random.randint(1000000000, 10000000000),
        "Timestamp": datetime.now().isoformat()
    }

def generate_base_price(symbol, is_index=False):
    """Generate consistent base prices based on symbol hash"""
    hash_val = abs(hash(symbol)) % 1000000

    if is_index:
        # Index values typically 500-1500
        return 500 + (hash_val % 1000)
    else:
        # Stock prices typically 10,000 - 500,000 VND
        return 10000 + (hash_val % 490000)

async def mock_data_producer():
    """Produce mock market data to Kafka"""
    logger.info("🚀 Starting Vietnamese market mock data producer...")

    stocks, indexes = get_symbols()
    logger.info(f"📊 Loaded symbols:")
    logger.info(f"   - Stocks ({len(stocks)}): {[s[0] for s in stocks[:10]]}{'...' if len(stocks) > 10 else ''}")
    logger.info(f"   - Indexes ({len(indexes)}): {[i[0] for i in indexes]}")

    # Store base prices for consistent simulation
    stock_base_prices = {}
    for symbol, _, _ in stocks:
        stock_base_prices[symbol] = generate_base_price(symbol, is_index=False)

    index_base_values = {}
    for symbol, _ in indexes:
        index_base_values[symbol] = generate_base_price(symbol, is_index=True)

    iteration = 0
    logger.info(f"🎯 Starting to produce data for {len(stocks)} stocks and {len(indexes)} indexes")

    while True:
        try:
            iteration += 1

            # More frequent summary logging for better visibility
            if iteration % 5 == 1:  # Log every 5th iteration
                logger.info(f"📈 Production iteration {iteration} - processing {len(stocks)} stocks and {len(indexes)} indexes")

            # Generate mock stock data
            stocks_produced = 0
            for symbol, name, market in stocks:
                mock_data = generate_mock_stock_data(symbol, stock_base_prices[symbol])
                topic = f'stock-{symbol}'

                logger.debug(f"Producing to topic: {topic}, data: {mock_data}")
                producer.produce(
                    topic,
                    json.dumps(mock_data).encode('utf-8'),
                    callback=delivery_report
                )
                stocks_produced += 1

            # Generate mock index data
            indexes_produced = 0
            for symbol, market in indexes:
                mock_data = generate_mock_index_data(symbol, index_base_values[symbol])
                topic = f'index-{symbol}'

                logger.debug(f"Producing to topic: {topic}, data: {mock_data}")
                producer.produce(
                    topic,
                    json.dumps(mock_data).encode('utf-8'),
                    callback=delivery_report
                )
                indexes_produced += 1

            # Flush messages
            producer.poll(0)

            # Detailed logging every 10 iterations
            if iteration % 10 == 0:
                logger.info(f"✅ Completed {iteration} iterations")
                logger.info(f"   📊 Produced data for {stocks_produced} stocks and {indexes_produced} indexes")
                logger.info(f"   🏛️ Markets covered: HOSE, HNX, UPCOM")

            # Wait before next iteration
            await asyncio.sleep(3)  # 3 seconds for stability

        except KeyboardInterrupt:
            logger.info("🛑 Stopping Vietnamese market mock data producer...")
            break
        except Exception as e:
            logger.error(f"❌ Error in mock data producer: {e}")
            logger.error(f"   Current iteration: {iteration}")
            await asyncio.sleep(5)

def test_ssi_connection():
    """Test if SSI connection is available"""
    try:
        import config
        from ssi_fc_data import fc_md_client

        logger.info("🔄 Testing SSI connection...")
        client = fc_md_client.MarketDataClient(config)
        logger.info("✅ SSI connection successful!")
        return True
    except Exception as e:
        logger.error(f"❌ SSI connection failed: {e}")
        logger.warning("🔄 Falling back to mock data mode")
        return False

async def main():
    """Main function - try SSI first, fallback to mock data"""

    logger.info("🇻🇳 Vietnamese Stock Market Data Producer")
    logger.info("=" * 50)

    # Test if SSI is available
    ssi_available = test_ssi_connection()

    if ssi_available:
        logger.info("🌐 Using real SSI data feed")
        # Import your original SSI code here
        # ... (your original main() code)
    else:
        logger.info("🎭 Using Vietnamese market mock data feed")
        logger.info("📊 Coverage: HOSE, HNX, UPCOM markets")
        await mock_data_producer()

if __name__ == "__main__":
    logger.info("🚀 Starting Vietnamese Market Data Producer...")
    asyncio.run(main())
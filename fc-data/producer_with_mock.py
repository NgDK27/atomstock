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
import redis

# Import centralized symbol configuration
from symbols_config import get_all_symbols, get_symbol_info, get_base_price

# Project setup
project_root = Path(__file__).parent.parent.parent
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

# Database configuration
DB_HOST = os.getenv('HOST') or 'localhost'
DB_NAME = os.getenv('DB_NAME') or 'capstone'
DB_USER = os.getenv('USER') or 'quando'
DB_PASSWORD = os.getenv('PASSWORD') or '808225'

# Initialize Redis for sharing current prices
redis_client = redis.Redis(host='localhost', port=6379, db=0)

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
                config_stocks, _ = get_all_symbols()
                stock_symbols = [(s[0], s[1], s[2]) for s in config_stocks]
                logger.info(f"Using {len(stock_symbols)} stocks from configuration")

            if db_indexes:
                index_symbols = [(row[0], row[1]) for row in db_indexes]
                logger.info(f"Using {len(index_symbols)} indexes from database")
            else:
                _, config_indexes = get_all_symbols()
                index_symbols = [(i[0], i[1]) for i in config_indexes]
                logger.info(f"Using {len(index_symbols)} indexes from configuration")

        except Exception as query_error:
            logger.error(f"Error querying database: {query_error}")
            # Use configured symbols as fallback
            config_stocks, config_indexes = get_all_symbols()
            stock_symbols = [(s[0], s[1], s[2]) for s in config_stocks]
            index_symbols = [(i[0], i[1]) for i in config_indexes]
            logger.info(f"Using configured symbols as fallback: {len(stock_symbols)} stocks, {len(index_symbols)} indexes")

        finally:
            cursor.close()
            conn.close()

    except Exception as error:
        logger.error(f"Error while connecting to database: {error}")
        # Use configured symbols as fallback
        config_stocks, config_indexes = get_all_symbols()
        stock_symbols = [(s[0], s[1], s[2]) for s in config_stocks]
        index_symbols = [(i[0], i[1]) for i in config_indexes]
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

def store_current_price_in_redis(symbol, price, is_index=False):
    """Store current price in Redis for historical API to use"""
    try:
        if is_index:
            key = f"current_index_price:{symbol}"
        else:
            key = f"current_stock_price:{symbol}"

        # Store with 1 hour expiration (will be refreshed every 3 seconds)
        redis_client.setex(key, 3600, str(price))
    except Exception as e:
        logger.error(f"Failed to store price in Redis for {symbol}: {e}")

def get_current_session_price(symbol, is_index=False):
    """Get or initialize current session price for a symbol"""
    try:
        if is_index:
            session_key = f"session_index_price:{symbol}"
            stable_key = f"stable_index_price:{symbol}"
        else:
            session_key = f"session_stock_price:{symbol}"
            stable_key = f"stable_stock_price:{symbol}"

        cached_price = redis_client.get(session_key)

        if cached_price:
            return float(cached_price)
        else:
            # Try to get from stable backup first
            stable_price = redis_client.get(stable_key)
            if stable_price:
                # Restore from stable backup
                session_price = float(stable_price)
                redis_client.setex(session_key, 86400, str(session_price))
                logger.info(f"🔄 Restored session price for {symbol} from backup: {session_price:.2f}")
                return session_price

            # Initialize with base price if no backup exists
            base_price = get_base_price(symbol)
            if base_price:
                # Use deterministic variation based on symbol to prevent random jumps
                import hashlib
                hash_val = int(hashlib.md5(symbol.encode()).hexdigest()[:8], 16)
                variation = (hash_val % 2000 - 1000) / 100000.0  # ±1% deterministic variation
                session_price = base_price * (1 + variation)

                # Store both session and stable backup
                redis_client.setex(session_key, 86400, str(session_price))
                redis_client.setex(stable_key, 172800, str(session_price))  # 2 day backup
                logger.info(f"🎯 Initialized session price for {symbol}: {session_price:.2f}")
                return session_price
            else:
                logger.error(f"❌ No base price configured for {symbol}")
                return 10000.0  # Emergency fallback

    except Exception as e:
        logger.error(f"Error getting session price for {symbol}: {e}")
        base_price = get_base_price(symbol)
        return base_price if base_price else 10000.0

def update_session_price(symbol, new_price, is_index=False):
    """Update the current session price"""
    try:
        if is_index:
            session_key = f"session_index_price:{symbol}"
            stable_key = f"stable_index_price:{symbol}"
        else:
            session_key = f"session_stock_price:{symbol}"
            stable_key = f"stable_stock_price:{symbol}"

        redis_client.setex(session_key, 86400, str(new_price))  # 24 hour expiry
        redis_client.setex(stable_key, 172800, str(new_price))  # 2 day backup
    except Exception as e:
        logger.error(f"Error updating session price for {symbol}: {e}")

def generate_mock_stock_data(symbol):
    """Generate realistic stock data with controlled fluctuations"""
    # Get current session price (slowly evolving throughout the day)
    current_session_price = get_current_session_price(symbol, is_index=False)

    # Generate small realistic fluctuation around current session price
    # Real Vietnamese stocks typically fluctuate ±0.5-2% per update
    fluctuation_percent = random.uniform(-0.015, 0.015)  # ±1.5% max per update
    price_change = current_session_price * fluctuation_percent
    new_price = current_session_price + price_change

    # Ensure price doesn't go negative and stays within reasonable bounds
    base_price = get_base_price(symbol)
    if base_price:
        # Keep price within ±20% of base price for the session
        min_price = base_price * 0.8
        max_price = base_price * 1.2
        new_price = max(min_price, min(new_price, max_price))

    # Gradually update session price with new price (weighted average for stability)
    updated_session_price = current_session_price * 0.95 + new_price * 0.05
    update_session_price(symbol, updated_session_price, is_index=False)

    # Store current price for API
    store_current_price_in_redis(symbol, new_price, is_index=False)

    # Calculate change from previous update
    try:
        prev_price_key = f"prev_stock_price:{symbol}"
        stored_prev = redis_client.get(prev_price_key)
        previous_price = float(stored_prev) if stored_prev else new_price
        redis_client.setex(prev_price_key, 3600, str(new_price))
    except:
        previous_price = new_price

    change = new_price - previous_price
    ratio_change = (change / previous_price) * 100 if previous_price > 0 else 0
    volume = random.randint(10000, 1000000)

    return {
        "Symbol": symbol,
        "Price": round(new_price, 2),
        "Change": round(change, 2),
        "RatioChange": round(ratio_change, 4),
        "Volume": volume,
        "Timestamp": datetime.now().isoformat()
    }

def generate_mock_index_data(index_id):
    """Generate realistic index data with controlled fluctuations"""
    # Get current session value (slowly evolving throughout the day)
    current_session_value = get_current_session_price(index_id, is_index=True)

    # Generate small realistic fluctuation around current session value
    # Indexes are typically less volatile than individual stocks
    fluctuation_percent = random.uniform(-0.005, 0.005)  # ±0.5% max per update (reduced)
    value_change = current_session_value * fluctuation_percent
    new_value = current_session_value + value_change

    # Gentle bounds checking - only prevent extreme values
    base_value = get_base_price(index_id)
    if base_value and new_value > 0:
        # Only enforce bounds if value goes too far from base (±25% instead of ±15%)
        min_value = base_value * 0.75
        max_value = base_value * 1.25

        # If outside bounds, gently pull back towards base instead of hard clipping
        if new_value < min_value:
            new_value = current_session_value * 0.99 + min_value * 0.01  # Gentle pull back
        elif new_value > max_value:
            new_value = current_session_value * 0.99 + max_value * 0.01  # Gentle pull back

    # Ensure value doesn't go negative
    new_value = max(new_value, base_value * 0.1 if base_value else 1.0)

    # More conservative session price update for stability
    updated_session_value = current_session_value * 0.98 + new_value * 0.02  # Slower evolution
    update_session_price(index_id, updated_session_value, is_index=True)

    # Store current value for API
    store_current_price_in_redis(index_id, new_value, is_index=True)

    # Calculate change from previous update
    try:
        prev_value_key = f"prev_index_value:{index_id}"
        stored_prev = redis_client.get(prev_value_key)
        previous_value = float(stored_prev) if stored_prev else new_value
        redis_client.setex(prev_value_key, 3600, str(new_value))
    except:
        previous_value = new_value

    change = new_value - previous_value
    ratio_change = (change / previous_value) * 100 if previous_value > 0 else 0

    return {
        "IndexId": index_id,
        "IndexValue": round(new_value, 2),
        "Change": round(change, 2),
        "RatioChange": round(ratio_change, 4),
        "TotalTrade": random.randint(1000, 10000),
        "TotalQtty": random.randint(1000000, 10000000),
        "TotalValue": random.randint(1000000000, 10000000000),
        "Timestamp": datetime.now().isoformat()
    }

def initialize_session_prices():
    """Initialize session prices for all symbols at start of day"""
    stocks, indexes = get_symbols()

    logger.info("🔄 Initializing session prices for trading day...")

    # Check if we already initialized today
    today = datetime.now().strftime('%Y%m%d')
    init_key = f"session_initialized:{today}"

    if redis_client.exists(init_key):
        logger.info("✅ Session prices already initialized for today")
        return

    # Initialize stock session prices
    for symbol, _, _ in stocks:
        get_current_session_price(symbol, is_index=False)

    # Initialize index session values
    for symbol, _ in indexes:
        get_current_session_price(symbol, is_index=True)

    # Mark as initialized for today
    redis_client.setex(init_key, 86400, "1")  # Expires at end of day
    logger.info("✅ Session prices initialized for all symbols")

async def mock_data_producer():
    """Produce mock market data to Kafka"""
    logger.info("🚀 Starting Vietnamese market mock data producer...")

    stocks, indexes = get_symbols()

    # Initialize session prices
    initialize_session_prices()

    iteration = 0
    logger.info(f"🎯 Starting to produce data for {len(stocks)} stocks and {len(indexes)} indexes")

    while True:
        try:
            iteration += 1

            if iteration % 20 == 1:
                logger.info(f"📈 Production iteration {iteration}")

            # Generate stock data with controlled fluctuations
            for symbol, name, market in stocks:
                mock_data = generate_mock_stock_data(symbol)

                topic = f'stock-{symbol}'
                producer.produce(
                    topic,
                    json.dumps(mock_data).encode('utf-8'),
                    callback=delivery_report
                )

            # Generate index data with controlled fluctuations
            for symbol, market in indexes:
                mock_data = generate_mock_index_data(symbol)

                topic = f'index-{symbol}'
                producer.produce(
                    topic,
                    json.dumps(mock_data).encode('utf-8'),
                    callback=delivery_report
                )

            producer.poll(0)

            if iteration % 50 == 0:
                logger.info(f"✅ Completed {iteration} iterations")
                # Log some sample prices for monitoring
                sample_symbols = [stocks[0][0], indexes[0][0]] if stocks and indexes else []
                for sample in sample_symbols:
                    current_price = get_current_session_price(sample, sample in [i[0] for i in indexes])
                    base_price = get_base_price(sample)
                    change_percent = ((current_price - base_price) / base_price * 100) if base_price else 0
                    logger.info(f"📊 {sample}: {current_price:.2f} ({change_percent:+.2f}% from base)")

            await asyncio.sleep(3)

        except KeyboardInterrupt:
            logger.info("🛑 Stopping Vietnamese market mock data producer...")
            break
        except Exception as e:
            logger.error(f"❌ Error in mock data producer: {e}")
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
        logger.info("💾 Storing current prices in Redis for API consistency")
        logger.info("🎯 Using realistic base prices with controlled fluctuations")
        await mock_data_producer()

if __name__ == "__main__":
    logger.info("🚀 Starting Vietnamese Market Data Producer...")
    asyncio.run(main())
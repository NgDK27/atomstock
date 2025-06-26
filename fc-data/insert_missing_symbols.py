#!/usr/bin/env python3
import psycopg2
import os
from dotenv import load_dotenv
from symbols_config import get_all_symbols
from pathlib import Path

# Load environment variables
project_root = Path(__file__).parent.parent.parent
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

DB_HOST = os.getenv('HOST') or 'localhost'
DB_NAME = os.getenv('DB_NAME') or 'capstone'
DB_USER = os.getenv('USER') or 'quando'
DB_PASSWORD = os.getenv('PASSWORD') or '808225'

def main():
    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()

    # Get market IDs
    cursor.execute("SELECT name, id FROM markets WHERE name IN ('HOSE', 'HNX', 'UPCOM')")
    markets = dict(cursor.fetchall())

    if not markets:
        print("No markets found")
        return

    # Get configured symbols
    stocks, indexes = get_all_symbols()

    # Insert stocks
    for symbol, name, market in stocks:
        market_id = markets.get('HOSE')  # Default all stocks to HOSE
        try:
            cursor.execute("""
                INSERT INTO stocks (symbol, en_name, market_id) 
                VALUES (%s, %s, %s)
                ON CONFLICT (symbol) DO NOTHING
            """, (symbol, name, market_id))
            print(f"Inserted/updated stock: {symbol}")
        except Exception as e:
            print(f"Error with stock {symbol}: {e}")

    # Insert indexes
    index_market_mapping = {
        'VNIndex': 'HOSE',
        'VN30': 'HOSE',
        'VNMidCap': 'HOSE',
        'VNSmallCap': 'HOSE',
        'VNAllShare': 'HOSE',
        'HNXIndex': 'HNX',
        'HNX30': 'HNX',
        'HNXCon': 'HNX',
        'HNXFin': 'HNX',
        'HNXLCap': 'HNX',
        'HNXMSci': 'HNX',
        'UpcomIndex': 'UPCOM'
    }

    for symbol, market in indexes:
        market_name = index_market_mapping.get(symbol, 'HOSE')
        market_id = markets.get(market_name)

        if market_id:
            try:
                cursor.execute("""
                    INSERT INTO indexes (symbol, market_id) 
                    VALUES (%s, %s)
                    ON CONFLICT (symbol) DO NOTHING
                """, (symbol, market_id))
                print(f"Inserted/updated index: {symbol}")
            except Exception as e:
                print(f"Error with index {symbol}: {e}")
        else:
            print(f"No market ID for {symbol}")

    conn.commit()
    cursor.close()
    conn.close()
    print("Done")

if __name__ == "__main__":
    main()
#!/usr/bin/env python3
"""
Insert configured Vietnamese symbols into PostgreSQL database
This ensures all your configured symbols exist in the database
"""

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

def get_market_ids(cursor):
    """Get market IDs for Vietnamese exchanges"""
    cursor.execute("SELECT id, name FROM markets WHERE name IN ('HOSE', 'HNX', 'UPCOM') ORDER BY name")
    markets = dict(cursor.fetchall())

    print(f"📊 Available markets:")
    for market_id, name in markets.items():
        print(f"   {name}: ID {market_id}")

    return markets

def check_existing_symbols(cursor, stocks, indexes):
    """Check which symbols already exist in the database"""
    print(f"\n🔍 Checking existing symbols in database...")

    # Check stocks
    stock_symbols = [s[0] for s in stocks]
    stock_placeholders = ','.join(['%s'] * len(stock_symbols))
    cursor.execute(f"""
        SELECT s.symbol, s.en_name, m.name
        FROM stocks s 
        JOIN markets m ON s.market_id = m.id 
        WHERE s.symbol IN ({stock_placeholders})
    """, stock_symbols)

    existing_stocks = cursor.fetchall()
    existing_stock_symbols = set(row[0] for row in existing_stocks)

    # Check indexes
    index_symbols = [i[0] for i in indexes]
    index_placeholders = ','.join(['%s'] * len(index_symbols))
    cursor.execute(f"""
        SELECT i.symbol, m.name
        FROM indexes i 
        JOIN markets m ON i.market_id = m.id 
        WHERE i.symbol IN ({index_placeholders})
    """, index_symbols)

    existing_indexes = cursor.fetchall()
    existing_index_symbols = set(row[0] for row in existing_indexes)

    print(f"   📈 Existing stocks: {len(existing_stocks)}/{len(stocks)}")
    print(f"   📊 Existing indexes: {len(existing_indexes)}/{len(indexes)}")

    # Find missing symbols
    missing_stocks = []
    for stock in stocks:
        if stock[0] not in existing_stock_symbols:
            missing_stocks.append(stock)

    missing_indexes = []
    for index in indexes:
        if index[0] not in existing_index_symbols:
            missing_indexes.append(index)

    print(f"   ❌ Missing stocks: {len(missing_stocks)}")
    print(f"   ❌ Missing indexes: {len(missing_indexes)}")

    if missing_stocks:
        print(f"   🔍 Missing stock symbols: {[s[0] for s in missing_stocks]}")

    if missing_indexes:
        print(f"   🔍 Missing index symbols: {[i[0] for i in missing_indexes]}")

    return existing_stocks, existing_indexes, missing_stocks, missing_indexes

def get_market_id_for_symbol(symbol, markets):
    """Determine which market a symbol should belong to"""
    # Most Vietnamese stocks are on HOSE
    # You can customize this logic based on your knowledge

    # Major indexes
    if symbol in ['VNIndex', 'VN30', 'VNMidCap', 'VNSmallCap', 'VNAllShare']:
        return markets.get('HOSE')
    elif symbol in ['HNXIndex', 'HNX30', 'HNXCon', 'HNXFin', 'HNXLCap', 'HNXMSci']:
        return markets.get('HNX')
    elif symbol in ['UpcomIndex']:
        return markets.get('UPCOM')

    # Most stocks default to HOSE (Ho Chi Minh Stock Exchange)
    # You can add specific mappings here if you know them
    return markets.get('HOSE')

def insert_missing_symbols(cursor, conn, missing_stocks, missing_indexes, markets):
    """Insert missing symbols into the database"""
    if not missing_stocks and not missing_indexes:
        print(f"✅ No missing symbols to insert!")
        return 0

    print(f"\n💾 Inserting missing symbols into database...")

    inserted_count = 0
    errors = []

    # Insert missing stocks
    for symbol, name, market in missing_stocks:
        market_id = get_market_id_for_symbol(symbol, markets)

        if not market_id:
            error_msg = f"No market ID found for {symbol}"
            print(f"   ❌ {error_msg}")
            errors.append(error_msg)
            continue

        try:
            cursor.execute("""
                INSERT INTO stocks (symbol, en_name, market_id) 
                VALUES (%s, %s, %s)
            """, (symbol, name, market_id))

            market_name = next(name for mid, name in markets.items() if mid == market_id)
            print(f"   ✅ Inserted stock: {symbol} - {name} ({market_name})")
            inserted_count += 1

        except psycopg2.IntegrityError as e:
            error_msg = f"Stock {symbol} already exists or constraint violation: {e}"
            print(f"   ⚠️ {error_msg}")
            errors.append(error_msg)
            conn.rollback()
        except Exception as e:
            error_msg = f"Failed to insert stock {symbol}: {e}"
            print(f"   ❌ {error_msg}")
            errors.append(error_msg)
            conn.rollback()

    # Insert missing indexes
    for symbol, market in missing_indexes:
        market_id = get_market_id_for_symbol(symbol, markets)

        if not market_id:
            error_msg = f"No market ID found for index {symbol}"
            print(f"   ❌ {error_msg}")
            errors.append(error_msg)
            continue

        try:
            cursor.execute("""
                INSERT INTO indexes (symbol, market_id) 
                VALUES (%s, %s)
            """, (symbol, market_id))

            market_name = next(name for mid, name in markets.items() if mid == market_id)
            print(f"   ✅ Inserted index: {symbol} ({market_name})")
            inserted_count += 1

        except psycopg2.IntegrityError as e:
            error_msg = f"Index {symbol} already exists or constraint violation: {e}"
            print(f"   ⚠️ {error_msg}")
            errors.append(error_msg)
            conn.rollback()
        except Exception as e:
            error_msg = f"Failed to insert index {symbol}: {e}"
            print(f"   ❌ {error_msg}")
            errors.append(error_msg)
            conn.rollback()

    return inserted_count, errors

def main():
    print("💾 Insert Vietnamese Symbols to Database")
    print("=" * 50)

    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cursor = conn.cursor()
        print(f"✅ Connected to PostgreSQL database: {DB_NAME}")
    except Exception as e:
        print(f"❌ Failed to connect to database: {e}")
        return

    # Get configured symbols
    stocks, indexes = get_all_symbols()
    print(f"\n📋 Configured symbols to check:")
    print(f"   📈 Stocks: {len(stocks)}")
    print(f"   📊 Indexes: {len(indexes)}")

    # Get market IDs
    try:
        markets = get_market_ids(cursor)
        if not markets:
            print(f"❌ No Vietnamese markets found in database!")
            print(f"   Expected markets: HOSE, HNX, UPCOM")
            return
    except Exception as e:
        print(f"❌ Failed to get market information: {e}")
        return

    # Check existing symbols
    existing_stocks, existing_indexes, missing_stocks, missing_indexes = check_existing_symbols(cursor, stocks, indexes)

    if not missing_stocks and not missing_indexes:
        print(f"\n🎉 All configured symbols already exist in the database!")
        print(f"   ✅ {len(existing_stocks)} stocks")
        print(f"   ✅ {len(existing_indexes)} indexes")
        cursor.close()
        conn.close()
        return

    # Show what will be inserted
    total_missing = len(missing_stocks) + len(missing_indexes)
    print(f"\n📝 Symbols to be inserted:")

    if missing_stocks:
        print(f"   📈 Stocks ({len(missing_stocks)}):")
        for symbol, name, market in missing_stocks:
            market_id = get_market_id_for_symbol(symbol, markets)
            market_name = next((name for mid, name in markets.items() if mid == market_id), "Unknown")
            print(f"      {symbol}: {name} → {market_name}")

    if missing_indexes:
        print(f"   📊 Indexes ({len(missing_indexes)}):")
        for symbol, market in missing_indexes:
            market_id = get_market_id_for_symbol(symbol, markets)
            market_name = next((name for mid, name in markets.items() if mid == market_id), "Unknown")
            print(f"      {symbol} → {market_name}")

    # Confirmation
    response = input(f"\nInsert {total_missing} missing symbols? (y/N): ")
    if response.lower() != 'y':
        print(f"❌ Cancelled - no symbols were inserted")
        cursor.close()
        conn.close()
        return

    # Insert missing symbols
    inserted_count, errors = insert_missing_symbols(cursor, conn, missing_stocks, missing_indexes, markets)

    # Commit changes
    try:
        conn.commit()
        print(f"\n✅ Successfully committed {inserted_count} symbols to database")
    except Exception as e:
        conn.rollback()
        print(f"\n❌ Failed to commit changes: {e}")
        inserted_count = 0

    # Final verification
    if inserted_count > 0:
        print(f"\n🔍 Verifying insertion...")
        final_existing_stocks, final_existing_indexes, final_missing_stocks, final_missing_indexes = check_existing_symbols(cursor, stocks, indexes)

        if not final_missing_stocks and not final_missing_indexes:
            print(f"🎉 Perfect! All {len(stocks)} stocks and {len(indexes)} indexes are now in the database!")
        else:
            print(f"⚠️ Some symbols are still missing:")
            if final_missing_stocks:
                print(f"   📈 Missing stocks: {[s[0] for s in final_missing_stocks]}")
            if final_missing_indexes:
                print(f"   📊 Missing indexes: {[i[0] for i in final_missing_indexes]}")

    # Show any errors
    if errors:
        print(f"\n⚠️ Errors encountered:")
        for error in errors:
            print(f"   - {error}")

    cursor.close()
    conn.close()

    print(f"\n💡 Next steps:")
    print(f"   1. Restart your producer to create Kafka topics for new symbols")
    print(f"   2. Restart your consumer to process the new data")
    print(f"   3. Run check_system_status.py to verify everything is working")

    print(f"\n✅ Database update completed!")

if __name__ == "__main__":
    main()
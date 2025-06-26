#!/usr/bin/env python3
"""
PostgreSQL database analyzer for Vietnamese Stock Market data
Analyzes the database and provides options for cleanup
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

def main():
    print("🔍 PostgreSQL Database Analyzer - Vietnamese Stock Market")
    print("=" * 70)
    
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
    configured_stock_symbols = set(s[0] for s in stocks)
    configured_index_symbols = set(i[0] for i in indexes)
    
    print(f"📋 Configured symbols: {len(configured_stock_symbols)} stocks, {len(configured_index_symbols)} indexes")
    
    # Analyze database structure
    print(f"\n🏗️ Database structure analysis:")
    
    # Check if tables exist
    cursor.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name IN ('stocks', 'indexes', 'markets')
        ORDER BY table_name
    """)
    tables = [row[0] for row in cursor.fetchall()]
    print(f"   📊 Found tables: {tables}")
    
    if 'markets' not in tables:
        print("❌ 'markets' table not found")
        return
    
    # Analyze markets
    cursor.execute("SELECT id, name FROM markets ORDER BY name")
    markets = cursor.fetchall()
    print(f"\n🏛️ Markets in database:")
    for market_id, market_name in markets:
        print(f"   {market_id}: {market_name}")
    
    vietnamese_market_ids = []
    for market_id, market_name in markets:
        if market_name in ['HOSE', 'HNX', 'UPCOM']:
            vietnamese_market_ids.append(market_id)
    
    print(f"   🇻🇳 Vietnamese market IDs: {vietnamese_market_ids}")
    
    # Analyze stocks table
    if 'stocks' in tables:
        print(f"\n📈 Stocks table analysis:")
        
        # Total stocks
        cursor.execute("SELECT COUNT(*) FROM stocks")
        total_stocks = cursor.fetchone()[0]
        print(f"   📊 Total stocks in database: {total_stocks}")
        
        # Vietnamese stocks
        if vietnamese_market_ids:
            cursor.execute("""
                SELECT COUNT(*) FROM stocks s 
                JOIN markets m ON s.market_id = m.id 
                WHERE m.name IN ('HOSE', 'HNX', 'UPCOM')
            """)
            vietnamese_stocks_count = cursor.fetchone()[0]
            print(f"   🇻🇳 Vietnamese stocks: {vietnamese_stocks_count}")
        
        # Stocks by market
        cursor.execute("""
            SELECT m.name, COUNT(*) 
            FROM stocks s 
            JOIN markets m ON s.market_id = m.id 
            GROUP BY m.name 
            ORDER BY COUNT(*) DESC
        """)
        stocks_by_market = cursor.fetchall()
        print(f"   📊 Stocks by market:")
        for market, count in stocks_by_market:
            print(f"      {market}: {count} stocks")
        
        # Check how many of our configured stocks exist
        stock_placeholders = ','.join(['%s'] * len(configured_stock_symbols))
        cursor.execute(f"""
            SELECT s.symbol, s.en_name, m.name
            FROM stocks s 
            JOIN markets m ON s.market_id = m.id 
            WHERE s.symbol IN ({stock_placeholders})
            ORDER BY s.symbol
        """, list(configured_stock_symbols))
        
        found_stocks = cursor.fetchall()
        found_stock_symbols = set(row[0] for row in found_stocks)
        missing_stocks = configured_stock_symbols - found_stock_symbols
        
        print(f"\n🎯 Configured stocks analysis:")
        print(f"   ✅ Found in database: {len(found_stocks)}/{len(configured_stock_symbols)}")
        print(f"   ❌ Missing from database: {len(missing_stocks)}")
        
        if missing_stocks:
            print(f"   🔍 Missing stocks: {sorted(list(missing_stocks))}")
        
        if found_stocks:
            print(f"\n📋 Sample of found configured stocks:")
            for symbol, name, market in found_stocks[:10]:
                print(f"      {symbol}: {name} ({market})")
            if len(found_stocks) > 10:
                print(f"      ... and {len(found_stocks) - 10} more")
    
    # Analyze indexes table
    if 'indexes' in tables:
        print(f"\n📊 Indexes table analysis:")
        
        # Total indexes
        cursor.execute("SELECT COUNT(*) FROM indexes")
        total_indexes = cursor.fetchone()[0]
        print(f"   📊 Total indexes in database: {total_indexes}")
        
        # Vietnamese indexes
        if vietnamese_market_ids:
            cursor.execute("""
                SELECT COUNT(*) FROM indexes i 
                JOIN markets m ON i.market_id = m.id 
                WHERE m.name IN ('HOSE', 'HNX', 'UPCOM')
            """)
            vietnamese_indexes_count = cursor.fetchone()[0]
            print(f"   🇻🇳 Vietnamese indexes: {vietnamese_indexes_count}")
        
        # Indexes by market
        cursor.execute("""
            SELECT m.name, COUNT(*) 
            FROM indexes i 
            JOIN markets m ON i.market_id = m.id 
            GROUP BY m.name 
            ORDER BY COUNT(*) DESC
        """)
        indexes_by_market = cursor.fetchall()
        print(f"   📊 Indexes by market:")
        for market, count in indexes_by_market:
            print(f"      {market}: {count} indexes")
        
        # Check configured indexes
        index_placeholders = ','.join(['%s'] * len(configured_index_symbols))
        cursor.execute(f"""
            SELECT i.symbol, m.name
            FROM indexes i 
            JOIN markets m ON i.market_id = m.id 
            WHERE i.symbol IN ({index_placeholders})
            ORDER BY i.symbol
        """, list(configured_index_symbols))
        
        found_indexes = cursor.fetchall()
        found_index_symbols = set(row[0] for row in found_indexes)
        missing_indexes = configured_index_symbols - found_index_symbols
        
        print(f"\n🎯 Configured indexes analysis:")
        print(f"   ✅ Found in database: {len(found_indexes)}/{len(configured_index_symbols)}")
        print(f"   ❌ Missing from database: {len(missing_indexes)}")
        
        if missing_indexes:
            print(f"   🔍 Missing indexes: {sorted(list(missing_indexes))}")
        
        if found_indexes:
            print(f"\n📋 Found configured indexes:")
            for symbol, market in found_indexes:
                print(f"      {symbol} ({market})")
    
    # Recommendations
    print(f"\n💡 Recommendations:")
    
    if len(found_stock_symbols) == len(configured_stock_symbols):
        print(f"   ✅ All configured stocks are in the database")
    else:
        print(f"   ⚠️ {len(missing_stocks)} configured stocks are missing from database")
        print(f"      Consider adding them or updating the configuration")
    
    if 'stocks' in tables and total_stocks > len(configured_stock_symbols) * 10:
        print(f"   ⚠️ Database has {total_stocks} stocks but you're only using {len(configured_stock_symbols)}")
        print(f"      Consider cleaning up the database for better performance")
    
    if len(found_index_symbols) == len(configured_index_symbols):
        print(f"   ✅ All configured indexes are in the database")
    else:
        print(f"   ⚠️ {len(missing_indexes)} configured indexes are missing from database")
    
    print(f"\n🔧 Available actions:")
    print(f"   1. Keep database as-is (filter in application code)")
    print(f"   2. Create missing symbols in database")
    print(f"   3. Generate database cleanup script (DANGEROUS)")
    
    action = input(f"\nChoose an action (1-3) or 'q' to quit: ")
    
    if action == '1':
        print(f"✅ No changes made. Your application will filter symbols as needed.")
    elif action == '2':
        create_missing_symbols(cursor, conn, missing_stocks, missing_indexes, vietnamese_market_ids)
    elif action == '3':
        generate_cleanup_script(cursor, configured_stock_symbols, configured_index_symbols)
    else:
        print(f"❌ No action taken")
    
    cursor.close()
    conn.close()
    print(f"\n✅ Database analysis completed!")

def create_missing_symbols(cursor, conn, missing_stocks, missing_indexes, vietnamese_market_ids):
    print(f"\n🔧 Creating missing symbols...")
    
    if not missing_stocks and not missing_indexes:
        print(f"✅ No missing symbols to create!")
        return
    
    # Find HOSE market ID (most common for Vietnamese stocks)
    hose_id = None
    for market_id in vietnamese_market_ids:
        cursor.execute("SELECT name FROM markets WHERE id = %s", (market_id,))
        market_name = cursor.fetchone()[0]
        if market_name == 'HOSE':
            hose_id = market_id
            break
    
    if not hose_id:
        print(f"❌ Could not find HOSE market ID")
        return
    
    # Get symbol information from our configuration
    stocks, indexes = get_all_symbols()
    stock_info = {s[0]: s for s in stocks}
    index_info = {i[0]: i for i in indexes}
    
    created_count = 0
    
    # Create missing stocks
    for symbol in missing_stocks:
        if symbol in stock_info:
            _, name, market = stock_info[symbol]
            try:
                cursor.execute("""
                    INSERT INTO stocks (symbol, en_name, market_id) 
                    VALUES (%s, %s, %s)
                """, (symbol, name, hose_id))
                print(f"   ✅ Created stock: {symbol} - {name}")
                created_count += 1
            except Exception as e:
                print(f"   ❌ Failed to create stock {symbol}: {e}")
    
    # Create missing indexes
    for symbol in missing_indexes:
        if symbol in index_info:
            _, market = index_info[symbol]
            try:
                cursor.execute("""
                    INSERT INTO indexes (symbol, market_id) 
                    VALUES (%s, %s)
                """, (symbol, hose_id))
                print(f"   ✅ Created index: {symbol}")
                created_count += 1
            except Exception as e:
                print(f"   ❌ Failed to create index {symbol}: {e}")
    
    if created_count > 0:
        try:
            conn.commit()
            print(f"✅ Successfully created {created_count} symbols")
        except Exception as e:
            conn.rollback()
            print(f"❌ Failed to commit changes: {e}")
    else:
        print(f"❌ No symbols were created")

def generate_cleanup_script(cursor, configured_stock_symbols, configured_index_symbols):
    print(f"\n⚠️ DANGER: Generating database cleanup script...")
    print(f"⚠️ This will create SQL to DELETE symbols not in your configuration!")
    
    response = input(f"Are you sure? Type 'GENERATE' to continue: ")
    if response != 'GENERATE':
        print(f"❌ Cancelled")
        return
    
    # Generate DELETE statements for stocks not in our configuration
    stock_placeholders = ','.join(["'%s'" % s for s in configured_stock_symbols])
    index_placeholders = ','.join(["'%s'" % s for s in configured_index_symbols])
    
    cleanup_script = f"""-- ⚠️ DANGEROUS: Database cleanup script for Vietnamese Stock Market
-- This will DELETE all stocks and indexes not in the configured symbols list
-- BACKUP YOUR DATABASE BEFORE RUNNING THIS!

-- Delete stocks not in configured list
DELETE FROM stocks 
WHERE symbol NOT IN ({stock_placeholders})
AND market_id IN (
    SELECT id FROM markets WHERE name IN ('HOSE', 'HNX', 'UPCOM')
);

-- Delete indexes not in configured list  
DELETE FROM indexes 
WHERE symbol NOT IN ({index_placeholders})
AND market_id IN (
    SELECT id FROM markets WHERE name IN ('HOSE', 'HNX', 'UPCOM')
);

-- Show remaining counts
SELECT 'Remaining stocks:', COUNT(*) FROM stocks s 
JOIN markets m ON s.market_id = m.id 
WHERE m.name IN ('HOSE', 'HNX', 'UPCOM');

SELECT 'Remaining indexes:', COUNT(*) FROM indexes i 
JOIN markets m ON i.market_id = m.id 
WHERE m.name IN ('HOSE', 'HNX', 'UPCOM');
"""
    
    script_filename = "cleanup_database.sql"
    with open(script_filename, 'w') as f:
        f.write(cleanup_script)
    
    print(f"✅ Generated cleanup script: {script_filename}")
    print(f"⚠️ REVIEW THE SCRIPT CAREFULLY before running!")
    print(f"⚠️ BACKUP YOUR DATABASE first!")

if __name__ == "__main__":
    main()

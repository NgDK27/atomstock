#!/usr/bin/env python3
"""
Redis cleanup script for Vietnamese Stock Market data
Removes old/invalid stock and index data from Redis and clears sorted sets
"""

import redis
import os
from dotenv import load_dotenv
from symbols_config import get_all_symbols

# Load environment variables
load_dotenv()

def main():
    print("🧹 Vietnamese Stock Market Redis Cleanup")
    print("=" * 50)
    
    # Connect to Redis
    redis_client = redis.Redis(host='localhost', port=6379, db=0)
    
    try:
        redis_client.ping()
        print("✅ Connected to Redis")
    except redis.ConnectionError:
        print("❌ Failed to connect to Redis")
        return
    
    # Get configured symbols
    stocks, indexes = get_all_symbols()
    configured_stock_symbols = set(s[0] for s in stocks)
    configured_index_symbols = set(i[0] for i in indexes)
    
    print(f"📊 Configured symbols: {len(configured_stock_symbols)} stocks, {len(configured_index_symbols)} indexes")
    
    # Find all existing keys
    stock_keys = redis_client.keys("stock:*")
    index_keys = redis_client.keys("index:*")
    
    print(f"🔍 Found in Redis: {len(stock_keys)} stock keys, {len(index_keys)} index keys")
    
    # Find symbols to remove (not in our configured list)
    stocks_to_remove = []
    for key in stock_keys:
        symbol = key.decode('utf-8').replace('stock:', '')
        if symbol not in configured_stock_symbols:
            stocks_to_remove.append(key.decode('utf-8'))
    
    indexes_to_remove = []
    for key in index_keys:
        symbol = key.decode('utf-8').replace('index:', '')
        if symbol not in configured_index_symbols:
            indexes_to_remove.append(key.decode('utf-8'))
    
    print(f"🗑️ Found {len(stocks_to_remove)} stock keys and {len(indexes_to_remove)} index keys to remove")
    
    if stocks_to_remove or indexes_to_remove:
        response = input("Do you want to remove these keys? (y/N): ")
        if response.lower() == 'y':
            # Remove invalid stock keys
            if stocks_to_remove:
                redis_client.delete(*stocks_to_remove)
                print(f"🗑️ Removed {len(stocks_to_remove)} stock keys")
            
            # Remove invalid index keys
            if indexes_to_remove:
                redis_client.delete(*indexes_to_remove)
                print(f"🗑️ Removed {len(indexes_to_remove)} index keys")
        else:
            print("❌ Cleanup cancelled")
    else:
        print("✅ No invalid keys found")
    
    # Clean up sorted sets
    print("\n🧹 Cleaning up sorted sets...")
    sorted_sets = ["stock_volume", "stock_increase", "stock_decrease"]
    
    for set_name in sorted_sets:
        # Get all members
        members = redis_client.zrange(set_name, 0, -1)
        invalid_members = []
        
        for member in members:
            symbol = member.decode('utf-8')
            if symbol not in configured_stock_symbols:
                invalid_members.append(symbol)
        
        if invalid_members:
            print(f"🗑️ Found {len(invalid_members)} invalid members in {set_name}")
            redis_client.zrem(set_name, *invalid_members)
            print(f"✅ Cleaned {set_name}")
        else:
            print(f"✅ {set_name} is clean")
    
    # Show final statistics
    print("\n📊 Final Redis state:")
    final_stock_keys = redis_client.keys("stock:*")
    final_index_keys = redis_client.keys("index:*")
    print(f"   📈 Stock keys: {len(final_stock_keys)}")
    print(f"   📊 Index keys: {len(final_index_keys)}")
    
    # Show sample of remaining keys
    if final_stock_keys:
        sample_stocks = [key.decode('utf-8').replace('stock:', '') for key in final_stock_keys[:10]]
        print(f"   📋 Sample stocks: {sample_stocks}")
    
    if final_index_keys:
        sample_indexes = [key.decode('utf-8').replace('index:', '') for key in final_index_keys]
        print(f"   📋 Indexes: {sample_indexes}")
    
    print("\n✅ Redis cleanup completed!")

if __name__ == "__main__":
    main()

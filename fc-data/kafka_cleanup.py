#!/usr/bin/env python3
"""
Kafka topic cleanup script for Vietnamese Stock Market data
DANGER: This will DELETE topics that are not in our configured symbols list
"""

from confluent_kafka.admin import AdminClient, ConfigResource
from confluent_kafka import KafkaError
import os
from dotenv import load_dotenv
from symbols_config import get_all_symbols
import time

# Load environment variables
load_dotenv()

def main():
    print("🧹 Kafka Topic Cleanup - Vietnamese Stock Market")
    print("=" * 60)
    print("⚠️  WARNING: This will DELETE Kafka topics!")
    print("⚠️  Only topics for configured symbols will be kept.")
    print("=" * 60)
    
    # Kafka configuration
    KAFKA_HOST = os.getenv('KAFKA_HOST') or '10.147.20.102'
    KAFKA_PORT = os.getenv('KAFKA_PORT') or '9092'
    
    kafka_config = {
        'bootstrap.servers': f"{KAFKA_HOST}:{KAFKA_PORT}",
        'request.timeout.ms': 30000,
    }
    
    admin_client = AdminClient(kafka_config)
    
    try:
        # Get topic metadata
        print(f"🔌 Connecting to Kafka at {KAFKA_HOST}:{KAFKA_PORT}")
        metadata = admin_client.list_topics(timeout=10)
        
        if not metadata.topics:
            print("❌ No topics found")
            return
            
        print(f"✅ Connected! Found {len(metadata.topics)} total topics")
            
    except Exception as e:
        print(f"❌ Failed to connect to Kafka: {e}")
        return
    
    # Get configured symbols
    stocks, indexes = get_all_symbols()
    configured_stock_symbols = set(s[0] for s in stocks)
    configured_index_symbols = set(i[0] for i in indexes)
    
    print(f"📋 Configured symbols: {len(configured_stock_symbols)} stocks, {len(configured_index_symbols)} indexes")
    
    # Find topics to keep and delete
    topics_to_keep = set()
    topics_to_delete = []
    
    # Add configured stock topics to keep list
    for symbol in configured_stock_symbols:
        topics_to_keep.add(f"stock-{symbol}")
    
    # Add configured index topics to keep list  
    for symbol in configured_index_symbols:
        topics_to_keep.add(f"index-{symbol}")
    
    print(f"🎯 Will keep {len(topics_to_keep)} topics for configured symbols")
    
    # Analyze all existing topics
    stock_topics_to_delete = []
    index_topics_to_delete = []
    other_topics = []
    
    for topic_name in metadata.topics.keys():
        if topic_name in topics_to_keep:
            continue  # Keep this topic
        elif topic_name.startswith('stock-'):
            stock_topics_to_delete.append(topic_name)
        elif topic_name.startswith('index-'):
            index_topics_to_delete.append(topic_name)
        else:
            other_topics.append(topic_name)
    
    total_to_delete = len(stock_topics_to_delete) + len(index_topics_to_delete)
    
    print(f"\n📊 Topics to delete:")
    print(f"   📈 Stock topics: {len(stock_topics_to_delete)}")
    print(f"   📊 Index topics: {len(index_topics_to_delete)}")
    print(f"   🔧 Other topics: {len(other_topics)} (will be ignored)")
    print(f"   🗑️ Total to delete: {total_to_delete}")
    
    if total_to_delete == 0:
        print("✅ No cleanup needed! All topics match configured symbols.")
        return
    
    # Show some examples
    if stock_topics_to_delete:
        print(f"\n📋 Sample stock topics to delete:")
        for topic in stock_topics_to_delete[:20]:
            symbol = topic.replace('stock-', '')
            print(f"   - {topic} (symbol: {symbol})")
        if len(stock_topics_to_delete) > 20:
            print(f"   ... and {len(stock_topics_to_delete) - 20} more stock topics")
    
    if index_topics_to_delete:
        print(f"\n📋 Index topics to delete:")
        for topic in index_topics_to_delete:
            symbol = topic.replace('index-', '')
            print(f"   - {topic} (symbol: {symbol})")
    
    # Confirmation
    print(f"\n⚠️  DANGER ZONE ⚠️")
    print(f"This will permanently delete {total_to_delete} Kafka topics!")
    print(f"Topics for configured symbols will be kept: {len(topics_to_keep)}")
    print(f"\nConfigured symbols that will be kept:")
    print(f"   Stocks: {sorted(list(configured_stock_symbols))}")
    print(f"   Indexes: {sorted(list(configured_index_symbols))}")
    
    response = input(f"\nAre you sure you want to delete {total_to_delete} topics? Type 'DELETE' to confirm: ")
    
    if response != 'DELETE':
        print("❌ Cleanup cancelled - no topics were deleted")
        return
    
    # Delete topics in batches
    topics_to_delete_list = stock_topics_to_delete + index_topics_to_delete
    
    print(f"\n🗑️ Starting deletion of {len(topics_to_delete_list)} topics...")
    
    # Delete in batches of 50 to avoid overwhelming Kafka
    batch_size = 50
    deleted_count = 0
    
    for i in range(0, len(topics_to_delete_list), batch_size):
        batch = topics_to_delete_list[i:i+batch_size]
        print(f"🗑️ Deleting batch {i//batch_size + 1}: {len(batch)} topics...")
        
        try:
            # Delete topics
            fs = admin_client.delete_topics(batch, operation_timeout=30)
            
            # Wait for deletion to complete
            for topic, f in fs.items():
                try:
                    f.result()  # The result itself is None
                    print(f"   ✅ Deleted: {topic}")
                    deleted_count += 1
                except Exception as e:
                    print(f"   ❌ Failed to delete {topic}: {e}")
            
            # Small delay between batches
            if i + batch_size < len(topics_to_delete_list):
                print("   ⏳ Waiting 2 seconds before next batch...")
                time.sleep(2)
                
        except Exception as e:
            print(f"❌ Error deleting batch: {e}")
            continue
    
    print(f"\n✅ Deletion completed!")
    print(f"   🗑️ Successfully deleted: {deleted_count} topics")
    print(f"   ❌ Failed to delete: {len(topics_to_delete_list) - deleted_count} topics")
    
    # Verify final state
    print(f"\n🔍 Verifying final state...")
    try:
        final_metadata = admin_client.list_topics(timeout=10)
        final_stock_topics = [t for t in final_metadata.topics.keys() if t.startswith('stock-')]
        final_index_topics = [t for t in final_metadata.topics.keys() if t.startswith('index-')]
        
        print(f"📊 Final topic count:")
        print(f"   📈 Stock topics remaining: {len(final_stock_topics)}")
        print(f"   📊 Index topics remaining: {len(final_index_topics)}")
        print(f"   🎯 Total remaining: {len(final_stock_topics) + len(final_index_topics)}")
        print(f"   📋 Expected: {len(topics_to_keep)}")
        
        if len(final_stock_topics) + len(final_index_topics) == len(topics_to_keep):
            print("🎉 Perfect! Topic count matches configured symbols.")
        else:
            print("⚠️ Topic count doesn't match expected. Some topics may need manual cleanup.")
        
    except Exception as e:
        print(f"❌ Could not verify final state: {e}")
    
    print(f"\n✅ Kafka cleanup completed!")
    print(f"💡 Next steps:")
    print(f"   1. Restart your consumer to subscribe to the remaining topics")
    print(f"   2. Run your producer to generate data for configured symbols")
    print(f"   3. Check that missing topics (like PME) are created")

if __name__ == "__main__":
    main()

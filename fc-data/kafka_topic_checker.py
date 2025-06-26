#!/usr/bin/env python3
"""
Kafka topic checker for Vietnamese Stock Market data
Lists all topics and compares with configured symbols
"""

from confluent_kafka.admin import AdminClient, ConfigResource
from confluent_kafka import KafkaError
import os
from dotenv import load_dotenv
from symbols_config import get_all_symbols

# Load environment variables
load_dotenv()

def main():
    print("🔍 Vietnamese Stock Market Kafka Topic Checker")
    print("=" * 60)
    
    # Kafka configuration
    KAFKA_HOST = os.getenv('KAFKA_HOST') or '10.147.20.102'
    KAFKA_PORT = os.getenv('KAFKA_PORT') or '9092'
    
    kafka_config = {
        'bootstrap.servers': f"{KAFKA_HOST}:{KAFKA_PORT}",
    }
    
    admin_client = AdminClient(kafka_config)
    
    try:
        # Get topic metadata
        print(f"🔌 Connecting to Kafka at {KAFKA_HOST}:{KAFKA_PORT}")
        metadata = admin_client.list_topics(timeout=10)
        
        if metadata.topics:
            print(f"✅ Connected successfully!")
            print(f"📊 Found {len(metadata.topics)} total topics")
        else:
            print("❌ No topics found")
            return
            
    except Exception as e:
        print(f"❌ Failed to connect to Kafka: {e}")
        return
    
    # Get configured symbols
    stocks, indexes = get_all_symbols()
    configured_stock_symbols = set(s[0] for s in stocks)
    configured_index_symbols = set(i[0] for i in indexes)
    
    print(f"\n📋 Configured symbols: {len(configured_stock_symbols)} stocks, {len(configured_index_symbols)} indexes")
    
    # Analyze topics
    stock_topics = []
    index_topics = []
    other_topics = []
    
    for topic_name in metadata.topics.keys():
        if topic_name.startswith('stock-'):
            stock_topics.append(topic_name)
        elif topic_name.startswith('index-'):
            index_topics.append(topic_name)
        else:
            other_topics.append(topic_name)
    
    print(f"\n🔍 Kafka topic analysis:")
    print(f"   📈 Stock topics: {len(stock_topics)}")
    print(f"   📊 Index topics: {len(index_topics)}")
    print(f"   🔧 Other topics: {len(other_topics)}")
    
    # Check which configured symbols have topics
    missing_stock_topics = []
    extra_stock_topics = []
    
    for symbol in configured_stock_symbols:
        topic_name = f"stock-{symbol}"
        if topic_name not in metadata.topics:
            missing_stock_topics.append(symbol)
    
    for topic in stock_topics:
        symbol = topic.replace('stock-', '')
        if symbol not in configured_stock_symbols:
            extra_stock_topics.append(symbol)
    
    missing_index_topics = []
    extra_index_topics = []
    
    for symbol in configured_index_symbols:
        topic_name = f"index-{symbol}"
        if topic_name not in metadata.topics:
            missing_index_topics.append(symbol)
    
    for topic in index_topics:
        symbol = topic.replace('index-', '')
        if symbol not in configured_index_symbols:
            extra_index_topics.append(symbol)
    
    # Report findings
    print(f"\n📊 Stock topic analysis:")
    print(f"   ✅ Configured stocks with topics: {len(configured_stock_symbols) - len(missing_stock_topics)}")
    print(f"   ❌ Missing topics for stocks: {len(missing_stock_topics)}")
    print(f"   ⚠️ Extra stock topics: {len(extra_stock_topics)}")
    
    if missing_stock_topics:
        print(f"   🔍 Missing stock topics: {missing_stock_topics[:10]}{'...' if len(missing_stock_topics) > 10 else ''}")
    
    if extra_stock_topics:
        print(f"   🔍 Extra stock topics: {extra_stock_topics[:10]}{'...' if len(extra_stock_topics) > 10 else ''}")
    
    print(f"\n📈 Index topic analysis:")
    print(f"   ✅ Configured indexes with topics: {len(configured_index_symbols) - len(missing_index_topics)}")
    print(f"   ❌ Missing topics for indexes: {len(missing_index_topics)}")
    print(f"   ⚠️ Extra index topics: {len(extra_index_topics)}")
    
    if missing_index_topics:
        print(f"   🔍 Missing index topics: {missing_index_topics}")
    
    if extra_index_topics:
        print(f"   🔍 Extra index topics: {extra_index_topics}")
    
    # Show other topics
    if other_topics:
        print(f"\n🔧 Other topics found:")
        for topic in other_topics[:20]:  # Show first 20
            print(f"   - {topic}")
        if len(other_topics) > 20:
            print(f"   ... and {len(other_topics) - 20} more")
    
    # Summary
    print(f"\n📝 Summary:")
    total_configured = len(configured_stock_symbols) + len(configured_index_symbols)
    total_missing = len(missing_stock_topics) + len(missing_index_topics)
    total_extra = len(extra_stock_topics) + len(extra_index_topics)
    
    print(f"   📊 Total configured symbols: {total_configured}")
    print(f"   ✅ Topics exist: {total_configured - total_missing}")
    print(f"   ❌ Missing topics: {total_missing}")
    print(f"   ⚠️ Extra topics: {total_extra}")
    
    if total_missing == 0 and total_extra == 0:
        print(f"   🎉 Perfect match! All configured symbols have topics, no extras found.")
    elif total_missing == 0:
        print(f"   ✅ All configured symbols have topics, but there are {total_extra} extra topics.")
    elif total_extra == 0:
        print(f"   ⚠️ Missing {total_missing} topics for configured symbols, but no extras.")
    else:
        print(f"   ⚠️ Mismatch detected: {total_missing} missing, {total_extra} extra topics.")
    
    print(f"\n💡 Recommendations:")
    if total_missing > 0:
        print(f"   - Start the producer to create missing topics")
    if total_extra > 0:
        print(f"   - Consider cleaning up extra topics or updating configuration")
    if total_missing == 0 and total_extra == 0:
        print(f"   - System is properly configured! 🎉")

if __name__ == "__main__":
    main()

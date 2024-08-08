#!/bin/bash

# Get the list of all topics
topics=$(docker exec oppenhomies-kafka-1 kafka-topics.sh --list --bootstrap-server localhost:9092)

# Loop through each topic and set the retention period
while IFS= read -r topic; do
    # Skip the __consumer_offsets topic
    if [ "$topic" != "__consumer_offsets" ]; then
        echo "Setting retention period for topic: $topic"
        docker exec oppenhomies-kafka-1 kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name "$topic" --alter --add-config retention.ms=1000
    else
        echo "Skipping __consumer_offsets topic"
    fi
done <<< "$topics"

echo "Retention period set to 1 hour for all applicable topics."
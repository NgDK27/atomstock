#!/bin/bash

# Create a temporary consumer group
temp_group="temp-consumer-group-$$"

# Get the list of all topics
topics=$(docker exec oppenhomies-kafka-1 kafka-topics.sh --list --bootstrap-server localhost:9092)

while IFS= read -r topic; do
    if [ "$topic" != "__consumer_offsets" ]; then
        echo "Checking offsets for topic: $topic"
        
        # Assign the temporary consumer group to the topic
        docker exec oppenhomies-kafka-1 kafka-consumer-groups.sh \
            --bootstrap-server localhost:9092 \
            --group $temp_group \
            --topic $topic \
            --reset-offsets --to-latest --execute

        # Get the offsets
        docker exec oppenhomies-kafka-1 kafka-consumer-groups.sh \
            --bootstrap-server localhost:9092 \
            --describe --group $temp_group
        
        # Delete the temporary consumer group
        docker exec oppenhomies-kafka-1 kafka-consumer-groups.sh \
            --bootstrap-server localhost:9092 \
            --delete --group $temp_group
    fi
done <<< "$topics"
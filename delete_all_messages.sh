#!/bin/bash

# Get the list of all topics
topics=$(docker exec oppenhomies-kafka-1 kafka-topics.sh --list --bootstrap-server localhost:9092)

while IFS= read -r topic; do
    if [ "$topic" != "__consumer_offsets" ]; then
        echo "Deleting messages for topic: $topic"
        
        # Get the number of partitions for this topic
        partitions=$(docker exec oppenhomies-kafka-1 kafka-topics.sh --describe --topic "$topic" --bootstrap-server localhost:9092 | grep -c "Partition:")
        
        # Create a JSON file for delete records
        json_content="{\n  \"partitions\": ["
        for i in $(seq 0 $((partitions-1))); do
            if [ $i -ne 0 ]; then
                json_content="${json_content},"
            fi
            json_content="${json_content}\n    {\"topic\": \"$topic\", \"partition\": $i, \"offset\": -1}"
        done
        json_content="${json_content}\n  ],\n  \"version\": 1\n}"
        
        # Use the JSON content to delete records
        echo -e "$json_content" | docker exec -i oppenhomies-kafka-1 kafka-delete-records.sh --bootstrap-server localhost:9092 --offset-json-file /dev/stdin
    fi
done <<< "$topics"

echo "Deletion process completed. Please check the offsets to confirm."
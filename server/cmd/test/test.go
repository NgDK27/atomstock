package main

import (
    "context"
    "fmt"
    
    "github.com/redis/go-redis/v9"
)

func checkRedisHash(client *redis.Client, key string) {
    ctx := context.Background()
    val, err := client.HGetAll(ctx, key).Result()
    if err != nil {
        fmt.Printf("Error getting hash %s: %v\n", key, err)
    } else if len(val) == 0 {
        fmt.Printf("Hash %s is empty or does not exist\n", key)
    } else {
        fmt.Printf("Values for hash %s:\n", key)
        for k, v := range val {
            fmt.Printf("  %s: %s\n", k, v)
        }
    }
}

func flushRedis(redisClient *redis.Client) error {
    ctx := context.Background()
    
    // FLUSHALL command
    err := redisClient.FlushAll(ctx).Err()
    if err != nil {
        return fmt.Errorf("failed to flush Redis: %v", err)
    }
    
    fmt.Printf("Successfully flushed all data from Redis")
    return nil
}

func main() {
    redisClient := redis.NewClient(&redis.Options{
        Addr:     "localhost:6379",
    })

    checkRedisHash(redisClient, "stock:MBB")
    // flushRedis(redisClient)
}
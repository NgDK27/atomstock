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
    
    err := redisClient.FlushAll(ctx).Err()
    if err != nil {
        return fmt.Errorf("failed to flush Redis: %v", err)
    }
    
    fmt.Printf("Successfully flushed all data from Redis")
    return nil
}

func setFakeData(client *redis.Client) error {
    ctx := context.Background()
    key := "index:VNIndex"
    
    data := map[string]interface{}{
        "IndexId":     "VNIndex",
        "IndexValue":  1232.56,
        "Change":      0.21,
        "RatioChange": 0.09,
        "TotalTrade":  327992,
        "TotalQtty":   589958790,
        "TotalValue":  14426729993080,
    }

    err := client.HMSet(ctx, key, data).Err()
    if err != nil {
        return fmt.Errorf("failed to set fake VNIndex data: %v", err)
    }

    key = "stock:DIG"
    
    data = map[string]interface{}{
        "Symbol":     "DIG",
        "Price":  26000,
        "Change":      0.30,
        "RatioChange": 0.42,
        "TotalVolume":  35761000,
    }

    err = client.HMSet(ctx, key, data).Err()
    if err != nil {
        return fmt.Errorf("failed to set fake DIG data: %v", err)
    }

    fmt.Println("Successfully set fake data in Redis")
    return nil
}

func main() {
    redisClient := redis.NewClient(&redis.Options{
        Addr:     "localhost:6379",
    })

    setFakeData(redisClient)

    // checkRedisHash(redisClient, "stock:DXG")
    // flushRedis(redisClient)
}
package services

import (
    "context"
    "encoding/json"
    "log"
    "strings"
    "fmt"

    "github.com/segmentio/kafka-go"
    "github.com/redis/go-redis/v9"
    "oppenhomies/server/internal/models"
)

type MarketDataService struct {
    reader      *kafka.Reader
    redisClient *redis.Client
}

func NewMarketDataService(reader *kafka.Reader, redisClient *redis.Client) (*MarketDataService, error) {
    return &MarketDataService{
        reader:      reader,
        redisClient: redisClient,
    }, nil
}

func (s *MarketDataService) Start(ctx context.Context) error {
    for {
        select {
        case <-ctx.Done():
            return nil
        default:
            msg, err := s.reader.FetchMessage(ctx)
            if err != nil {
                log.Printf("Error fetching message: %v", err)
                continue
            }

            if err := s.processMessage(msg); err != nil {
                log.Printf("Error processing message: %v", err)
            }

            if err := s.reader.CommitMessages(ctx, msg); err != nil {
                log.Printf("Error committing message: %v", err)
            }
        }
    }
}

func (s *MarketDataService) processMessage(msg kafka.Message) error {
    topic := msg.Topic

    if strings.HasPrefix(topic, "stock-") {
        symbol := strings.TrimPrefix(topic, "stock-")
        return s.processStockData(msg.Value, symbol)
    } else if strings.HasPrefix(topic, "index-") {
        indexId := strings.TrimPrefix(topic, "index-")
        return s.processIndexData(msg.Value, indexId)
    } else {
        log.Printf("Unknown topic: %s", topic)
        return nil
    }
}

func (s *MarketDataService) processStockData(data []byte, symbol string) error {
    var stockData models.StockData
    err := json.Unmarshal(data, &stockData)
    if err != nil {
        return fmt.Errorf("error unmarshaling stock data: %v", err)
    }

    ctx := context.Background()
    key := "stock:" + symbol


    if stockData.RatioChange != -100 {
        _, err = s.redisClient.HSet(ctx, key, map[string]interface{}{
            "Price":       stockData.Price,
            "Change":      stockData.Change,
            "RatioChange": stockData.RatioChange,
            "Volume":      stockData.Volume,
        }).Result()
    
        if err != nil {
            return fmt.Errorf("error storing stock data in Redis: %v", err)
        }
        // Update sorted sets
        s.redisClient.ZAdd(ctx, "stock_volume", redis.Z{Score: stockData.Volume, Member: symbol})
        s.redisClient.ZAdd(ctx, "stock_increase", redis.Z{Score: stockData.RatioChange, Member: symbol})
        s.redisClient.ZAdd(ctx, "stock_decrease", redis.Z{Score: -stockData.RatioChange, Member: symbol})
    } else {
        _, err = s.redisClient.HSet(ctx, key, map[string]interface{}{
            "Price":       stockData.Change * -1,
            "Change":      0.00,
            "RatioChange": 0.00,
            "Volume":      stockData.Volume,
        }).Result()
    
        if err != nil {
            return fmt.Errorf("error storing stock data in Redis: %v", err)
        }

        log.Printf("Skipping update of sorted sets for %s because RatioChange is -100", symbol)
    }


    // Publish update for real-time subscribers
    s.publishStockUpdate(ctx, stockData)

    log.Printf("Stored and published stock data for %s", symbol)
    return nil
}

func (s *MarketDataService) processIndexData(data []byte, indexId string) error {
    var indexData models.IndexData
    err := json.Unmarshal(data, &indexData)
    if err != nil {
        return fmt.Errorf("error unmarshaling index data: %v", err)
    }

    ctx := context.Background()
    key := "index:" + indexId

    _, err = s.redisClient.HSet(ctx, key, map[string]interface{}{
        "IndexValue":  indexData.IndexValue,
        "Change":      indexData.Change,
        "RatioChange": indexData.RatioChange,
        "TotalTrade":  indexData.TotalTrade,
        "TotalQtty":   indexData.TotalQtty,
        "TotalValue":  indexData.TotalValue,
    }).Result()

    if err != nil {
        return fmt.Errorf("error storing index data in Redis: %v", err)
    }

    // Publish update for real-time subscribers
    s.publishIndexUpdate(ctx, indexData)

    log.Printf("Stored and published index data for %s", indexId)
    return nil
}


func (s *MarketDataService) publishStockUpdate(ctx context.Context, data models.StockData) {
    message, _ := json.Marshal(data)
    s.redisClient.Publish(ctx, "stock_updates", message)
}

func (s *MarketDataService) publishIndexUpdate(ctx context.Context, data models.IndexData) {
    message, _ := json.Marshal(data)
    s.redisClient.Publish(ctx, "index_updates", message)
}

func (s *MarketDataService) Stop() {
    s.reader.Close()
}
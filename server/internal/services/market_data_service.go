// server/internal/services/market_data_services.go
package services

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"strings"
	"time"

	"oppenhomies/server/internal/models"

	"github.com/confluentinc/confluent-kafka-go/v2/kafka"
	"github.com/redis/go-redis/v9"
)

type MarketDataService struct {
    consumer    *kafka.Consumer
    redisClient *redis.Client
    running     bool
}

func NewMarketDataService(consumer *kafka.Consumer, redisClient *redis.Client) (*MarketDataService, error) {
    return &MarketDataService{
        consumer:    consumer,
        redisClient: redisClient,
        running:     false,
    }, nil
}

func (s *MarketDataService) Start(ctx context.Context) error {
	s.running = true
	log.Println("🚀 Starting market data service...")

	for s.running {
		select {
		case <-ctx.Done():
			log.Println("Context cancelled, stopping market data service")
			return ctx.Err()
		default:
			// Poll for messages with a timeout
			ev := s.consumer.Poll(1000) // Increased timeout to 1 second

			switch e := ev.(type) {
			case *kafka.Message:
				// Process the message
				if err := s.processMessage(e); err != nil {
					log.Printf("❌ Error processing message: %v", err)
				} else {
					// Commit the message after successful processing
					if _, err := s.consumer.CommitMessage(e); err != nil {
						log.Printf("❌ Error committing message: %v", err)
					}
				}

			case kafka.Error:
				// Handle errors
				log.Printf("❌ Kafka error: %v", e)
				if e.Code() == kafka.ErrAllBrokersDown {
					log.Printf("🔄 All brokers down, retrying...")
					time.Sleep(2 * time.Second)
				}

			case nil:
				// No message received within timeout, continue

			default:
				// Other events (like partition assignment changes)
				log.Printf("📡 Kafka event: %v", e)
			}
		}
	}

	return nil
}

func (s *MarketDataService) processMessage(msg *kafka.Message) error {
    if msg.TopicPartition.Topic == nil {
        return fmt.Errorf("message topic is nil")
    }

    topic := *msg.TopicPartition.Topic

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

	// Ensure the symbol in the data matches the topic symbol
	stockData.Symbol = symbol

	ctx := context.Background()
	key := "stock:" + symbol

	// Always store new data (simplified logic for mock data)
	_, err = s.redisClient.HSet(ctx, key, map[string]interface{}{
		"Price":       stockData.Price,
		"Change":      stockData.Change,
		"RatioChange": stockData.RatioChange,
		"Volume":      stockData.Volume,
	}).Result()

	if err != nil {
		return fmt.Errorf("error storing stock data in Redis: %v", err)
	}

	// Update sorted sets for market overview
	s.redisClient.ZAdd(ctx, "stock_volume", redis.Z{Score: stockData.Volume, Member: symbol})
	s.redisClient.ZAdd(ctx, "stock_increase", redis.Z{Score: stockData.RatioChange, Member: symbol})
	s.redisClient.ZAdd(ctx, "stock_decrease", redis.Z{Score: -stockData.RatioChange, Member: symbol})

	// Always publish update for real-time subscribers
	s.publishStockUpdate(ctx, stockData)

	log.Printf("✅ Stored and published stock data for %s: Price=%.2f, Change=%.2f%%",
		symbol, stockData.Price, stockData.RatioChange)

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


func (s *MarketDataService) processIndexData(data []byte, indexId string) error {
	var indexData models.IndexData
	err := json.Unmarshal(data, &indexData)
	if err != nil {
		return fmt.Errorf("error unmarshaling index data: %v", err)
	}

	// Ensure the indexId in the data matches the topic indexId
	indexData.IndexId = indexId

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

	log.Printf("✅ Stored and published index data for %s: Value=%.2f, Change=%.2f%%",
		indexId, indexData.IndexValue, indexData.RatioChange)
	return nil
}

func (s *MarketDataService) Stop() {
    log.Println("Stopping market data service...")
    s.running = false
    if s.consumer != nil {
        s.consumer.Close()
    }
}
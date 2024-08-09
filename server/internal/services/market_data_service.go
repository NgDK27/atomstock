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
	log.Printf("Received message from topic: %s", topic)

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

	_, err = s.redisClient.HMSet(ctx, key, map[string]interface{}{
		"RefPrice":      stockData.RefPrice,
		"Ceiling":       stockData.Ceiling,
		"Floor":         stockData.Floor,
		"Price":         stockData.Price,
		"Change":        stockData.Change,
		"RatioChange":   stockData.RatioChange,
		"Open":          stockData.Open,
		"High":          stockData.High,
		"Low":           stockData.Low,
		"Volume":        stockData.Volume,
		"TotalVal":      stockData.TotalVal,
		"TradingTime":   stockData.TradingTime,
		"TradingDate":   stockData.TradingDate,
	}).Result()

	if err != nil {
		return fmt.Errorf("error storing stock data in Redis: %v", err)
	}

	// Verify data in Redis
	_, err = s.redisClient.HGetAll(ctx, key).Result()
	if err != nil {
		log.Printf("Error retrieving stock data from Redis: %v", err)
	} else {
		log.Printf("Stored stock data for %s", symbol)
	}

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

	_, err = s.redisClient.HMSet(ctx, key, map[string]interface{}{
		"IndexValue":    indexData.IndexValue,
		"Change":        indexData.Change,
		"RatioChange":   indexData.RatioChange,
		"TotalTrade":    indexData.TotalTrade,
		"TotalQtty":     indexData.TotalQtty,
		"TotalValue":    indexData.TotalValue,
		"TradingTime":   indexData.TradingTime,
		"TradingDate":   indexData.TradingDate,
	}).Result()

	if err != nil {
		return fmt.Errorf("error storing index data in Redis: %v", err)
	}

	// Verify data in Redis
	_, err = s.redisClient.HGetAll(ctx, key).Result()
	if err != nil {
		log.Printf("Error retrieving index data from Redis: %v", err)
	} else {
		log.Printf("Stored index data for %s", indexId)
	}
	
	return nil
}

func (s *MarketDataService) Stop() {
	s.reader.Close()
}
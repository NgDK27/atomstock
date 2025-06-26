// server/consumer/consumer.go
package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	"github.com/confluentinc/confluent-kafka-go/v2/kafka"
	"github.com/joho/godotenv"
	"github.com/redis/go-redis/v9"
	"oppenhomies/server/internal/services"
	"oppenhomies/server/internal/symbols"
	_ "github.com/lib/pq"
)

var (
	db *sql.DB
)

func ConnectDatabase() {
	host := os.Getenv("HOST")
	port, _ := strconv.Atoi(os.Getenv("PORT"))
	user := os.Getenv("USER")
	dbname := os.Getenv("DB_NAME")
	pass := os.Getenv("PASSWORD")

	psqlSetup := fmt.Sprintf("host=%s port=%d user=%s dbname=%s password=%s sslmode=disable",
		host, port, user, dbname, pass)
	database, err := sql.Open("postgres", psqlSetup)
	if err != nil {
		log.Fatalf("Error while connecting to the database: %v", err)
	}
	db = database
	log.Println("✅ Successfully connected to the database!")
}

func getTopics() ([]string, error) {
	var topics []string

	log.Println("🔍 Creating topics for configured Vietnamese market symbols...")

	// Get symbols from centralized configuration
	stockSymbols := symbols.GetStockSymbols()
	indexSymbols := symbols.GetIndexSymbols()

	// Add stock topics
	log.Printf("📊 Adding %d stock topics", len(stockSymbols))
	for _, symbol := range stockSymbols {
		topics = append(topics, fmt.Sprintf("stock-%s", symbol))
	}

	// Add index topics
	log.Printf("📈 Adding %d index topics", len(indexSymbols))
	for _, symbol := range indexSymbols {
		topics = append(topics, fmt.Sprintf("index-%s", symbol))
	}

	log.Printf("🎯 Total topics created: %d", len(topics))
	log.Printf("📋 Sample topics: %v", topics[:min(10, len(topics))])
	log.Printf("🏛️ Markets covered: HOSE, HNX, UPCOM")
	log.Printf("📊 Stock symbols: %d configured symbols", len(stockSymbols))
	log.Printf("📈 Index symbols: %d configured symbols", len(indexSymbols))

	return topics, nil
}

func validateDatabaseSymbols() {
	log.Println("🔍 Validating database contains our configured symbols...")

	stockSymbols := symbols.GetStockSymbols()
	indexSymbols := symbols.GetIndexSymbols()

	// Check how many of our stocks are in the database
	stockPlaceholders := make([]string, len(stockSymbols))
	stockArgs := make([]interface{}, len(stockSymbols))
	for i, symbol := range stockSymbols {
		stockPlaceholders[i] = fmt.Sprintf("$%d", i+1)
		stockArgs[i] = symbol
	}

	stockQuery := fmt.Sprintf(`
		SELECT COUNT(*)
		FROM stocks s
		JOIN markets m ON s.market_id = m.id
		WHERE s.symbol IN (%s) AND m.name IN ('HOSE', 'HNX', 'UPCOM')
	`, strings.Join(stockPlaceholders, ","))

	var stockCount int
	err := db.QueryRow(stockQuery, stockArgs...).Scan(&stockCount)
	if err != nil {
		log.Printf("⚠️ Warning: Could not validate stock symbols in database: %v", err)
	} else {
		log.Printf("📊 Database contains %d/%d configured stock symbols", stockCount, len(stockSymbols))
	}

	// Check how many of our indexes are in the database
	indexPlaceholders := make([]string, len(indexSymbols))
	indexArgs := make([]interface{}, len(indexSymbols))
	for i, symbol := range indexSymbols {
		indexPlaceholders[i] = fmt.Sprintf("$%d", i+1)
		indexArgs[i] = symbol
	}

	indexQuery := fmt.Sprintf(`
		SELECT COUNT(*)
		FROM indexes i
		JOIN markets m ON i.market_id = m.id
		WHERE i.symbol IN (%s) AND m.name IN ('HOSE', 'HNX', 'UPCOM')
	`, strings.Join(indexPlaceholders, ","))

	var indexCount int
	err = db.QueryRow(indexQuery, indexArgs...).Scan(&indexCount)
	if err != nil {
		log.Printf("⚠️ Warning: Could not validate index symbols in database: %v", err)
	} else {
		log.Printf("📈 Database contains %d/%d configured index symbols", indexCount, len(indexSymbols))
	}

	// Check total symbols in database
	var totalStocks, totalIndexes int
	db.QueryRow("SELECT COUNT(*) FROM stocks s JOIN markets m ON s.market_id = m.id WHERE m.name IN ('HOSE', 'HNX', 'UPCOM')").Scan(&totalStocks)
	db.QueryRow("SELECT COUNT(*) FROM indexes i JOIN markets m ON i.market_id = m.id WHERE m.name IN ('HOSE', 'HNX', 'UPCOM')").Scan(&totalIndexes)

	log.Printf("📊 Database totals: %d stocks, %d indexes (we're using %d stocks, %d indexes)",
		totalStocks, totalIndexes, len(stockSymbols), len(indexSymbols))
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func setupKafkaConsumer(brokers []string, topics []string) (*kafka.Consumer, error) {
	config := &kafka.ConfigMap{
		"bootstrap.servers":        strings.Join(brokers, ","),
		"group.id":                "vietnamese-market-consumer-curated",
		"auto.offset.reset":       "latest",
		"enable.auto.commit":      false,
		"session.timeout.ms":      30000,
		"heartbeat.interval.ms":   3000,
		"max.poll.interval.ms":    300000,
		"fetch.min.bytes":         1,
	}

	consumer, err := kafka.NewConsumer(config)
	if err != nil {
		return nil, fmt.Errorf("failed to create consumer: %v", err)
	}

	log.Printf("🔗 Subscribing to %d Vietnamese market topics (curated symbols only)", len(topics))
	log.Printf("📊 Markets: HOSE, HNX, UPCOM")

	err = consumer.SubscribeTopics(topics, nil)
	if err != nil {
		consumer.Close()
		return nil, fmt.Errorf("failed to subscribe to topics: %v", err)
	}

	log.Println("✅ Successfully subscribed to curated Vietnamese market topics")
	return consumer, nil
}

func checkRedisConnection(client *redis.Client) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := client.Ping(ctx).Result()
	return err
}

func main() {
	log.Println("🇻🇳 Vietnamese Stock Market Consumer (Curated Symbols)")
	log.Println("=" + strings.Repeat("=", 60))

	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: Error loading .env file: %v", err)
	}

	ConnectDatabase()
	defer db.Close()

	// Validate that our configured symbols exist in the database
	validateDatabaseSymbols()

	redisClient := redis.NewClient(&redis.Options{
		Addr: os.Getenv("REDIS_ADDR"),
	})

	if err := checkRedisConnection(redisClient); err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}
	log.Println("✅ Successfully connected to Redis")

	// Get topics for our curated symbols only
	topics, err := getTopics()
	if err != nil {
		log.Fatalf("Failed to get Vietnamese market topics: %v", err)
	}

	if len(topics) == 0 {
		log.Fatalf("No Vietnamese market topics configured")
	}

	kafkaBrokers := os.Getenv("KAFKA_BROKERS")
	brokers := strings.Split(kafkaBrokers, ",")

	log.Printf("🔌 Connecting to Kafka brokers: %v", brokers)

	consumer, err := setupKafkaConsumer(brokers, topics)
	if err != nil {
		log.Fatalf("Failed to setup Kafka consumer: %v", err)
	}
	defer consumer.Close()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	marketDataService, err := services.NewMarketDataService(consumer, redisClient)
	if err != nil {
		log.Fatalf("Failed to create market data service: %v", err)
	}

	log.Printf("🚀 Starting Vietnamese market data service...")
	log.Printf("📊 Monitoring %d topics for curated symbols", len(topics))
	log.Printf("🏛️ Markets: HOSE, HNX, UPCOM")
	log.Printf("📈 Indexes: %d configured", len(symbols.GetIndexSymbols()))

	go func() {
		if err := marketDataService.Start(ctx); err != nil {
			log.Printf("Market data service error: %v", err)
			cancel()
		}
	}()

	// Set up graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	log.Println("✅ Vietnamese market consumer is running (curated symbols only)...")
	log.Printf("📈 Processing data for %d stocks and %d indexes", len(symbols.GetStockSymbols()), len(symbols.GetIndexSymbols()))
	log.Println("Press Ctrl+C to shutdown gracefully")

	<-sigChan

	log.Println("🛑 Shutting down Vietnamese market consumer...")
	cancel()
	marketDataService.Stop()
	redisClient.Close()
	consumer.Close()
	db.Close()
	log.Println("✅ Shutdown complete")
}
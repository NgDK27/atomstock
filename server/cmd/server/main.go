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

	"github.com/joho/godotenv"
	"github.com/redis/go-redis/v9"
	"github.com/segmentio/kafka-go"
	"oppenhomies/server/internal/services"
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
	log.Println("Successfully connected to the database!")
}

func getTopics() ([]string, error) {
	var topics []string

	rows, err := db.Query("SELECT symbol FROM stocks")
	if err != nil {
		return nil, fmt.Errorf("error querying stocks: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var symbol string
		if err := rows.Scan(&symbol); err != nil {
			return nil, fmt.Errorf("error scanning stock symbol: %v", err)
		}
		topics = append(topics, fmt.Sprintf("stock-%s", symbol))
	}

	rows, err = db.Query("SELECT symbol FROM indexes")
	if err != nil {
		return nil, fmt.Errorf("error querying indexes: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var symbol string
		if err := rows.Scan(&symbol); err != nil {
			return nil, fmt.Errorf("error scanning index symbol: %v", err)
		}
		topics = append(topics, fmt.Sprintf("index-%s", symbol))
	}

	return topics, nil
}

func setupKafkaReader(brokers []string, topics []string) (*kafka.Reader, error) {
	reader := kafka.NewReader(kafka.ReaderConfig{
		Brokers:        brokers,
		GroupID:        "market-data-consumer",
		GroupTopics:    topics,
		MinBytes:       10e3,
		MaxBytes:       10e6,
		CommitInterval: time.Second,
		StartOffset:    kafka.LastOffset,
		RetentionTime:  time.Hour,
	})

	return reader, nil
}

func checkRedisConnection(client *redis.Client) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := client.Ping(ctx).Result()
	return err
}

func main() {
	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: Error loading .env file: %v", err)
	}

	ConnectDatabase()
	defer db.Close()

	redisClient := redis.NewClient(&redis.Options{
		Addr: os.Getenv("REDIS_ADDR"),
	})

	
	if err := checkRedisConnection(redisClient); err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}
	log.Println("Successfully connected to Redis")

	topics, err := getTopics()
	if err != nil {
		log.Fatalf("Failed to get topics from database: %v", err)
	}
	log.Printf("Topics to consume: %v", topics)

	kafkaBrokers := os.Getenv("KAFKA_BROKERS")
	if kafkaBrokers == "" {
		kafkaBrokers = "localhost:9092"
	}
	brokers := strings.Split(kafkaBrokers, ",")

	reader, err := setupKafkaReader(brokers, topics)
	if err != nil {
		log.Fatalf("Failed to setup Kafka reader: %v", err)
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	marketDataService, err := services.NewMarketDataService(reader, redisClient)
	if err != nil {
		log.Fatalf("Failed to create market data service: %v", err)
	}

	go func() {
		if err := marketDataService.Start(ctx); err != nil {
			log.Printf("Market data service error: %v", err)
			cancel()
		}
	}()

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)
	<-sigChan

	log.Println("Shutting down...")
	cancel()
	marketDataService.Stop()
	redisClient.Close()
	db.Close()
	log.Println("Shutdown complete")
}
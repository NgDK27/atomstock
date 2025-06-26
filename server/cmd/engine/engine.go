// server/engine/engine.go
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

	return topics, nil
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

	topics, err := getTopics()
	if err != nil {
		log.Fatalf("Failed to get topics from database: %v", err)
	}

	redisClient := redis.NewClient(&redis.Options{
		Addr: os.Getenv("REDIS_ADDR"),
	})

	if err := checkRedisConnection(redisClient); err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}
	log.Println("Successfully connected to Redis")


	kafkaBrokers := strings.Split(os.Getenv("KAFKA_BROKERS"), ",")
    automatedTradingService := services.NewAutomatedTradingService(db, redisClient, kafkaBrokers, topics)
    portfolioService := services.NewPortfolioService(db, redisClient)

	// Start services
    go automatedTradingService.Start()
    go portfolioService.Start()

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)
	<-sigChan

	log.Println("Shutting down...")
	automatedTradingService.Stop()
	portfolioService.Stop()
	redisClient.Close()
	db.Close()
	log.Println("Shutdown complete")
}
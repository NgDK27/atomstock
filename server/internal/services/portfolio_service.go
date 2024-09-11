package services

import (
    "context"
    "database/sql"
    "encoding/json"
    "log"
    "sync"
    "time"
    "fmt"

    "github.com/gorilla/websocket"
    "github.com/redis/go-redis/v9"
    "oppenhomies/server/internal/models"
)

type PortfolioService struct {
    db          *sql.DB
    redisClient *redis.Client
    subscribers map[string][]*websocket.Conn
    mu          sync.Mutex
}

func NewPortfolioService(db *sql.DB, redisClient *redis.Client) *PortfolioService {
    return &PortfolioService{
        db:          db,
        redisClient: redisClient,
        subscribers: make(map[string][]*websocket.Conn),
    }
}

func (s *PortfolioService) Start() {
    go s.listenForUpdates()
    go s.periodicPersistence()
}

func (s *PortfolioService) Stop() {
    // Close all websocket connections
    s.mu.Lock()
    defer s.mu.Unlock()
    for _, conns := range s.subscribers {
        for _, conn := range conns {
            conn.Close()
        }
    }
}

func (s *PortfolioService) listenForUpdates() {
    pubsub := s.redisClient.Subscribe(context.Background(), "stock_updates", "trade_executions")
    defer pubsub.Close()

    for {
        msg, err := pubsub.ReceiveMessage(context.Background())
        if err != nil {
            log.Printf("Error receiving message: %v", err)
            continue
        }

        switch msg.Channel {
        case "stock_updates":
            var stockData models.StockData
            err = json.Unmarshal([]byte(msg.Payload), &stockData)
            if err != nil {
                log.Printf("Error unmarshaling stock data: %v", err)
                continue
            }
            s.processStockUpdate(stockData)
        case "trade_executions":
            var tradeExecution models.TradeExecution
            err = json.Unmarshal([]byte(msg.Payload), &tradeExecution)
            if err != nil {
                log.Printf("Error unmarshaling trade execution: %v", err)
                continue
            }
            s.processTradeExecution(tradeExecution)
        }
    }
}

func (s *PortfolioService) processStockUpdate(stockData models.StockData) {
    rows, err := s.db.Query(`
        SELECT DISTINCT p.id, p.user_id, p.total_value
        FROM portfolios p
        JOIN trades t ON p.user_id = t.user_id
        WHERE t.symbol = $1 AND t.status = 'OPEN'`, stockData.Symbol)
    if err != nil {
        log.Printf("Error fetching affected portfolios: %v", err)
        return
    }
    defer rows.Close()

    for rows.Next() {
        var portfolio models.Portfolio
        err := rows.Scan(&portfolio.ID, &portfolio.UserID, &portfolio.TotalValue)
        if err != nil {
            log.Printf("Error scanning portfolio: %v", err)
            continue
        }

        newValue, err := s.calculatePortfolioValue(portfolio.UserID, stockData)
        if err != nil {
            log.Printf("Error calculating portfolio value: %v", err)
            continue
        }

        // Update Redis
        s.redisClient.HSet(context.Background(), fmt.Sprintf("portfolio:%s", portfolio.UserID), "total_value", newValue)

        // Publish update
        s.publishPortfolioUpdate(portfolio.UserID, newValue)
    }
}

func (s *PortfolioService) processTradeExecution(tradeExecution models.TradeExecution) {
    // Update portfolio in Redis and PostgreSQL
    portfolio, err := s.GetPortfolio(tradeExecution.UserID)
    if err != nil {
        log.Printf("Error getting portfolio: %v", err)
        return
    }

    var tradeValue float64
    var newValue float64
    if tradeExecution.ExitPrice > 0 {
        tradeValue = float64(tradeExecution.Shares) * tradeExecution.ExitPrice
        if tradeValue > portfolio.TotalValue{
            newValue = tradeValue - portfolio.TotalValue
        } else {
            newValue = portfolio.TotalValue - tradeValue
        }
    } else {
        tradeValue = float64(tradeExecution.Shares) * tradeExecution.EntryPrice
        newValue = portfolio.TotalValue + tradeValue
    }


    // Update Redis
    s.redisClient.HSet(context.Background(), fmt.Sprintf("portfolio:%s", tradeExecution.UserID), "total_value", newValue)

    // Update PostgreSQL
    _, err = s.db.Exec("UPDATE portfolios SET total_value = $1, last_updated = NOW() WHERE user_id = $2", newValue, tradeExecution.UserID)
    if err != nil {
        log.Printf("Error updating portfolio in PostgreSQL: %v", err)
    }

    // Publish update
    s.publishPortfolioUpdate(tradeExecution.UserID, newValue)
}

func (s *PortfolioService) calculatePortfolioValue(userID string, stockData models.StockData) (float64, error) {
    var totalValue float64

    rows, err := s.db.Query(`
        SELECT symbol, SUM(shares) as total_shares
        FROM trades
        WHERE user_id = $1 AND status = 'OPEN'
        GROUP BY symbol`, userID)
    if err != nil {
        return 0, err
    }
    defer rows.Close()

    for rows.Next() {
        var symbol string
        var shares int
        err := rows.Scan(&symbol, &shares)
        if err != nil {
            return 0, err
        }

        var price float64
        if symbol == stockData.Symbol {
            price = stockData.Price
        } else {
            // Fetch price from Redis
            price, err = s.redisClient.HGet(context.Background(), fmt.Sprintf("stock:%s", symbol), "Price").Float64()
            if err != nil {
                log.Printf("Error fetching price for %s: %v", symbol, err)
                continue
            }
        }

        totalValue += float64(shares) * price
    }

    return totalValue, nil
}

func (s *PortfolioService) publishPortfolioUpdate(userID string, newValue float64) {
    update := models.PortfolioUpdate{
        UserID:     userID,
        TotalValue: newValue,
        UpdateTime: time.Now(),
    }

    updateJSON, err := json.Marshal(update)
    if err != nil {
        log.Printf("Error marshaling portfolio update: %v", err)
        return
    }

    s.redisClient.Publish(context.Background(), "portfolio_updates", updateJSON)
}

func (s *PortfolioService) GetPortfolio(userID string) (models.Portfolio, error) {
    var portfolio models.Portfolio
    portfolio.UserID = userID

    // Try to get from Redis first
    totalValue, err := s.redisClient.HGet(context.Background(), fmt.Sprintf("portfolio:%s", userID), "total_value").Float64()
    if err == nil {
        portfolio.TotalValue = totalValue
    } else {
        // Fallback to PostgreSQL
        err = s.db.QueryRow("SELECT total_value FROM portfolios WHERE user_id = $1", userID).Scan(&portfolio.TotalValue)
        if err != nil {
            return portfolio, err
        }
    }

    rows, err := s.db.Query(`
        SELECT t.symbol, t.shares, t.entry_price
        FROM trades t
        WHERE t.user_id = $1 AND t.status = 'OPEN'
        GROUP BY t.symbol, t.entry_price, t.shares`, userID)
    if err != nil {
        return portfolio, err
    }
    defer rows.Close()

    for rows.Next() {
        var position models.PortfolioPosition
        err := rows.Scan(&position.Symbol, &position.Shares, &position.Price)
        if err != nil {
            return portfolio, err
        }

        // Get current price from Redis
        position.CurrentPrice, err = s.redisClient.HGet(context.Background(), fmt.Sprintf("stock:%s", position.Symbol), "Price").Float64()
        if err != nil {
            log.Printf("Error fetching current price for %s: %v", position.Symbol, err)
            continue
        }

        position.Value = float64(position.Shares) * position.CurrentPrice
        portfolio.Positions = append(portfolio.Positions, position)
    }

    return portfolio, nil
}

func (s *PortfolioService) SubscribeToUpdates(userID string, conn *websocket.Conn) {
    s.mu.Lock()
    defer s.mu.Unlock()
    s.subscribers[userID] = append(s.subscribers[userID], conn)
}

func (s *PortfolioService) UnsubscribeFromUpdates(userID string, conn *websocket.Conn) {
    s.mu.Lock()
    defer s.mu.Unlock()
    conns := s.subscribers[userID]
    for i, c := range conns {
        if c == conn {
            s.subscribers[userID] = append(conns[:i], conns[i+1:]...)
            break
        }
    }
}

func (s *PortfolioService) periodicPersistence() {
    ticker := time.NewTicker(5 * time.Minute)
    defer ticker.Stop()

    for range ticker.C {
        s.persistPortfolios()
    }
}

func (s *PortfolioService) persistPortfolios() {
    keys, err := s.redisClient.Keys(context.Background(), "portfolio:*").Result()
    if err != nil {
        log.Printf("Error fetching portfolio keys from Redis: %v", err)
        return
    }

    for _, key := range keys {
        userID := key[10:] // Remove "portfolio:" prefix
        totalValue, err := s.redisClient.HGet(context.Background(), key, "total_value").Float64()
        if err != nil {
            log.Printf("Error getting portfolio value from Redis for user %s: %v", userID, err)
            continue
        }

        _, err = s.db.Exec(`
            UPDATE portfolios
            SET total_value = $1, last_updated = NOW()
            WHERE user_id = $2`,
            totalValue, userID)
        if err != nil {
            log.Printf("Error syncing portfolio for user %s to PostgreSQL: %v", userID, err)
        }
    }
}
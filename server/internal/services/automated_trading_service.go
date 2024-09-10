package services

import (
    "context"
    "database/sql"
    "encoding/json"
    "log"
    "time"
	"fmt"

    "github.com/redis/go-redis/v9"
    "github.com/segmentio/kafka-go"
    "oppenhomies/server/internal/models"
)

type AutomatedTradingService struct {
    db          *sql.DB
    redisClient *redis.Client
    kafkaReader *kafka.Reader
    stopChan    chan struct{}
}


func NewAutomatedTradingService(db *sql.DB, redisClient *redis.Client, kafkaBrokers []string, topics []string) *AutomatedTradingService {
    stockTopics := topics
    
    reader := kafka.NewReader(kafka.ReaderConfig{
        Brokers: kafkaBrokers,
        GroupID: "automated-trading-group",
        GroupTopics:    stockTopics,
        CommitInterval: 200 * time.Millisecond,
        StartOffset:    kafka.LastOffset,
        MaxWait:        500 * time.Millisecond,
    })

    return &AutomatedTradingService{
        db:          db,
        redisClient: redisClient,
        kafkaReader: reader,
        stopChan:    make(chan struct{}),
    }
}

func (s *AutomatedTradingService) Start() {
    go s.run()
}

func (s *AutomatedTradingService) Stop() {
    close(s.stopChan)
    s.kafkaReader.Close()
}

func (s *AutomatedTradingService) run() {
    for {
        select {
        case <-s.stopChan:
            return
        default:
            message, err := s.kafkaReader.ReadMessage(context.Background())
            if err != nil {
                log.Printf("Error reading Kafka message: %v", err)
                continue
            }
            s.processMessage(message)
        }
    }
}

func (s *AutomatedTradingService) processMessage(message kafka.Message) {
    var stockData models.StockData
    err := json.Unmarshal(message.Value, &stockData)
    if err != nil {
        log.Printf("Error unmarshaling stock data: %v", err)
        return
    }

    rules, err := s.fetchActiveRules(stockData.Symbol)
    if err != nil {
        log.Printf("Error fetching active rules: %v", err)
        return
    }

    for _, rule := range rules {
        if s.shouldExecuteTrade(rule, stockData) {
            s.executeTrade(rule, stockData)
        }
    }

    s.checkOpenTrades(stockData)
}

func (s *AutomatedTradingService) fetchActiveRules(symbol string) ([]models.TradingRule, error) {
    rows, err := s.db.Query("SELECT * FROM trading_rules WHERE symbol = $1 AND is_active = true", symbol)
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    var rules []models.TradingRule
    for rows.Next() {
        var rule models.TradingRule
        err := rows.Scan(&rule.ID, &rule.UserID, &rule.Symbol, &rule.Shares, &rule.EntryConditionType,
            &rule.EntryTriggerValue, &rule.EntryRangeType, &rule.TrailingStopLossPercentage,
            &rule.TakeProfitPercentage, &rule.IsActive, &rule.CreatedAt)
        if err != nil {
            return nil, err
        }
        rules = append(rules, rule)
    }
    return rules, nil
}

func (s *AutomatedTradingService) shouldExecuteTrade(rule models.TradingRule, data models.StockData) bool {
    if rule.EntryConditionType == "PRICE" {
        if rule.EntryRangeType == "ABOVE" && data.Price > rule.EntryTriggerValue {
            return true
        }
        if rule.EntryRangeType == "BELOW" && data.Price < rule.EntryTriggerValue {
            return true
        }
    }
    return false
}

func (s *AutomatedTradingService) executeTrade(rule models.TradingRule, data models.StockData) {
    // Check user's balance
    balance, err := s.getUserBalance(rule.UserID)
    if err != nil {
        log.Printf("Error getting user balance: %v", err)
        return
    }

    tradeValue := float64(rule.Shares) * data.Price
    if balance < tradeValue {
        log.Printf("Insufficient balance for user %s to execute trade", rule.UserID)
        return
    }

    // Calculate take profit price
    takeProfitPrice := data.Price * (1 + rule.TakeProfitPercentage/100)

    // Execute the trade
    tx, err := s.db.BeginTx(context.Background(), nil)
    if err != nil {
        log.Printf("Error starting transaction: %v", err)
        return
    }
    defer tx.Rollback()

    // Insert trade record
    _, err = tx.Exec(`
        INSERT INTO trades (
            rule_id, user_id, symbol, entry_price, highest_price, entry_time, 
            shares, status, take_profit_price
        )
        VALUES ($1, $2, $3, $4, $4, NOW(), $5, 'OPEN', $6)`,
        rule.ID, rule.UserID, rule.Symbol, data.Price, rule.Shares, takeProfitPrice)
    if err != nil {
        log.Printf("Error inserting trade: %v", err)
        return
    }

    // Update user's balance
    _, err = tx.Exec("UPDATE users SET balance = balance - $1 WHERE id = $2", tradeValue, rule.UserID)
    if err != nil {
        log.Printf("Error updating user balance: %v", err)
        return
    }

    if err := tx.Commit(); err != nil {
        log.Printf("Error committing transaction: %v", err)
        return
    }

    // Update Redis
    s.redisClient.HIncrByFloat(context.Background(), fmt.Sprintf("user:%s", rule.UserID), "balance", -tradeValue)

    // Publish trade execution
    tradeExecution := models.TradeExecution{
        UserID:     rule.UserID,
        Symbol:     rule.Symbol,
        Shares:     rule.Shares,
        EntryPrice: data.Price,
        EntryTime:  time.Now(),
    }
    tradeJSON, _ := json.Marshal(tradeExecution)
    s.redisClient.Publish(context.Background(), "trade_executions", tradeJSON)

    log.Printf("Trade executed for user %s: %d shares of %s at %f", rule.UserID, rule.Shares, rule.Symbol, data.Price)
}

func (s *AutomatedTradingService) updateHighestPrice(tx *sql.Tx, trade *models.Trade, currentPrice float64) error {
    if currentPrice > trade.HighestPrice {
        trade.HighestPrice = currentPrice
        _, err := tx.Exec("UPDATE trades SET highest_price = $1 WHERE id = $2", currentPrice, trade.ID)
        return err
    }
    return nil
}

func (s *AutomatedTradingService) checkOpenTrades(data models.StockData) {
    tx, err := s.db.BeginTx(context.Background(), nil)
    if err != nil {
        log.Printf("Error starting transaction: %v", err)
        return
    }
    defer tx.Rollback()

    rows, err := tx.Query(`
        SELECT t.id, t.user_id, t.entry_price, t.highest_price, t.shares, t.take_profit_price, r.trailing_stop_loss_percentage, r.id
        FROM trades t
        JOIN trading_rules r ON t.rule_id = r.id
        WHERE t.symbol = $1 AND t.status = 'OPEN'
        FOR UPDATE`, data.Symbol)
    if err != nil {
        log.Printf("Error fetching open trades: %v", err)
        return
    }
    defer rows.Close()

    for rows.Next() {
        var trade models.Trade
        var trailingStopLoss float64
        var ruleID int
        err := rows.Scan(&trade.ID, &trade.UserID, &trade.EntryPrice, &trade.HighestPrice, &trade.Shares, &trade.TakeProfitPrice, &trailingStopLoss, &ruleID)
        if err != nil {
            log.Printf("Error scanning trade: %v", err)
            continue
        }

        trade.Symbol = data.Symbol
        trade.RuleID = ruleID

        if err := s.updateHighestPrice(tx, &trade, data.Price); err != nil {
            log.Printf("Error updating highest price: %v", err)
            continue
        }

        if data.Price >= trade.TakeProfitPrice {
            if err := s.closeTrade(tx, trade, data.Price, "TAKE_PROFIT"); err != nil {
                log.Printf("Error closing trade for take profit: %v", err)
                continue
            }
        } else {
            stopLossPrice := trade.HighestPrice * (1 - trailingStopLoss/100)
            if data.Price <= stopLossPrice {
                if err := s.closeTrade(tx, trade, data.Price, "STOP_LOSS"); err != nil {
                    log.Printf("Error closing trade for stop loss: %v", err)
                    continue
                }
            }
        }
    }

    if err := tx.Commit(); err != nil {
        log.Printf("Error committing transaction: %v", err)
    }
}

func (s *AutomatedTradingService) closeTrade(tx *sql.Tx, trade models.Trade, exitPrice float64, exitType string) error {
    // Update trade record
    _, err := tx.Exec(`
        UPDATE trades 
        SET exit_price = $1, exit_time = NOW(), exit_type = $2, status = 'CLOSED'
        WHERE id = $3`,
        exitPrice, exitType, trade.ID)
    if err != nil {
        return fmt.Errorf("error updating trade: %v", err)
    }

    // Update user's balance
    tradeValue := float64(trade.Shares) * exitPrice
    _, err = tx.Exec("UPDATE users SET balance = balance + $1 WHERE id = $2", tradeValue, trade.UserID)
    if err != nil {
        return fmt.Errorf("error updating user balance: %v", err)
    }

    // Set the associated rule to inactive
    _, err = tx.Exec("UPDATE trading_rules SET is_active = false WHERE id = $1", trade.RuleID)
    if err != nil {
        return fmt.Errorf("error setting rule to inactive: %v", err)
    }

    // Update Redis (consider moving this outside the transaction if it's slow)
    s.redisClient.HIncrByFloat(context.Background(), fmt.Sprintf("user:%s", trade.UserID), "balance", tradeValue)

    // Publish trade closure
    tradeExecution := models.TradeExecution{
        UserID:    trade.UserID,
        Symbol:    trade.Symbol,
        Shares:    trade.Shares,
        ExitPrice: exitPrice,
        ExitTime:  time.Now(),
        ExitType:  exitType,
    }
    tradeJSON, _ := json.Marshal(tradeExecution)
    s.redisClient.Publish(context.Background(), "trade_executions", tradeJSON)

    log.Printf("Trade closed for user %s: %d shares of %s at %f (%s)", 
        trade.UserID, trade.Shares, trade.Symbol, exitPrice, exitType)

    return nil
}

func (s *AutomatedTradingService) getUserBalance(userID string) (float64, error) {
    // Try Redis first
    balance, err := s.redisClient.HGet(context.Background(), fmt.Sprintf("user:%s", userID), "balance").Float64()
    if err == nil {
        return balance, nil
    }

    // Fallback to PostgreSQL
    var dbBalance float64
    err = s.db.QueryRow("SELECT balance FROM users WHERE id = $1", userID).Scan(&dbBalance)
    if err != nil {
        return 0, err
    }

    // Cache in Redis for future
    s.redisClient.HSet(context.Background(), fmt.Sprintf("user:%s", userID), "balance", dbBalance)

    return dbBalance, nil
}
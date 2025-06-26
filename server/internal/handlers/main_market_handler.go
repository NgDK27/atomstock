package handlers

import (
    "context"
    "encoding/json"
    "net/http"
    "strconv"
    "log"
    "strings"
    "sync"
    "database/sql"
    "sort"

    "github.com/gin-gonic/gin"
    "github.com/gorilla/websocket"
    "github.com/redis/go-redis/v9"
    "oppenhomies/server/internal/models"
)

var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
        return true 
    },
}

// Development mode - bypass market hours check
var developmentMode = true // Set to false for production

type MainMarketConnection struct {
    conn          *websocket.Conn
    initialStocks map[string]bool
    mu            sync.Mutex
}

func GetMainMarketData(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx := c.Request.Context()
        category := c.Query("category")

        var response gin.H
        switch category {
        case "volume":
            response = gin.H{"topVolume": getTopN(ctx, redisClient, "stock_volume", 30)}
        case "increase":
            response = gin.H{"topIncrease": getTopN(ctx, redisClient, "stock_increase", 30)}
        case "decrease":
            response = gin.H{"topDecrease": getTopN(ctx, redisClient, "stock_decrease", 30)}
        case "indexes":
            response = gin.H{"indexes": getAllIndexes(ctx, redisClient)}
        default:
            response = getInitialMainMarketData(ctx, redisClient)
        }

        c.JSON(http.StatusOK, response)
    }
}

func MainMarketWebSocket(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
        if err != nil {
            log.Printf("Failed to set websocket upgrade: %v", err)
            return
        }
        defer conn.Close()

        ctx, cancel := context.WithCancel(c.Request.Context())
        defer cancel()

        initialData := getInitialMainMarketData(ctx, redisClient)
        err = conn.WriteJSON(initialData)
        if err != nil {
            log.Printf("Failed to send initial data: %v", err)
            return
        }

        initialStocks := make(map[string]bool)
        for _, category := range []string{"topVolume", "topIncrease", "topDecrease"} {
            if stockList, ok := initialData[category].([]models.StockData); ok {
                for _, stock := range stockList {
                    initialStocks[stock.Symbol] = true
                }
            }
        }

        mainMarketConn := &MainMarketConnection{
            conn:          conn,
            initialStocks: initialStocks,
        }

        stockUpdateChan := make(chan models.StockData, 100)
        indexUpdateChan := make(chan models.IndexData, 100)

        go listenForUpdates(ctx, redisClient, stockUpdateChan, indexUpdateChan)

        for {
            select {
            case stockUpdate := <-stockUpdateChan:
                handleStockUpdate(mainMarketConn, stockUpdate)
            case indexUpdate := <-indexUpdateChan:
                handleIndexUpdate(mainMarketConn, indexUpdate)
            case <-ctx.Done():
                return
            }
        }
    }
}

func handleStockUpdate(conn *MainMarketConnection, update models.StockData) {
    conn.mu.Lock()
    defer conn.mu.Unlock()

    if conn.initialStocks[update.Symbol] {
        // Convert to format expected by Dart
        stockUpdate := gin.H{
            "type": "stockUpdate",
            "data": gin.H{
                "Symbol": update.Symbol,
                "Price": update.Price,
                "Change": update.Change,
                "RatioChange": update.RatioChange,
                "Volume": update.Volume,
            },
        }
        err := conn.conn.WriteJSON(stockUpdate)
        if err != nil {
            log.Printf("Failed to send stock update: %v", err)
        }
    }
}

func handleIndexUpdate(conn *MainMarketConnection, update models.IndexData) {
    if update.IndexId == "VNIndex" || update.IndexId == "VN30" {
        // Convert to format expected by Dart
        indexUpdate := gin.H{
            "type": "indexUpdate",
            "data": gin.H{
                "IndexId": update.IndexId,
                "IndexValue": update.IndexValue,
                "Change": update.Change,
                "RatioChange": update.RatioChange,
                "TotalTrade": update.TotalTrade,
                "TotalQtty": update.TotalQtty,
                "TotalValue": update.TotalValue,
            },
        }
        err := conn.conn.WriteJSON(indexUpdate)
        if err != nil {
            log.Printf("Failed to send index update: %v", err)
        }
    }
}

func listenForUpdates(ctx context.Context, redisClient *redis.Client, stockChan chan<- models.StockData, indexChan chan<- models.IndexData) {
    pubsub := redisClient.Subscribe(ctx, "stock_updates", "index_updates")
    defer pubsub.Close()

    for {
        select {
        case msg := <-pubsub.Channel():
            switch msg.Channel {
            case "stock_updates":
                var update models.StockData
                if err := json.Unmarshal([]byte(msg.Payload), &update); err == nil {
                    stockChan <- update
                }
            case "index_updates":
                var update models.IndexData
                if err := json.Unmarshal([]byte(msg.Payload), &update); err == nil {
                    indexChan <- update
                }
            }
        case <-ctx.Done():
            return
        }
    }
}

func getInitialMainMarketData(ctx context.Context, redisClient *redis.Client) gin.H {
    return gin.H{
        "topVolume":  getTopN(ctx, redisClient, "stock_volume", 10),
        "topIncrease": getTopN(ctx, redisClient, "stock_increase", 3),
        "topDecrease":  getTopN(ctx, redisClient, "stock_decrease", 3),
        "indexes":    getDefaultIndexes(ctx, redisClient),
    }
}

func getTopN(ctx context.Context, redisClient *redis.Client, key string, n int) []models.StockData {
    results, err := redisClient.ZRevRangeWithScores(ctx, key, 0, int64(n-1)).Result()
    if err != nil {
        log.Printf("Error fetching top stocks: %v", err)
        return []models.StockData{}
    }

    stocks := make([]models.StockData, 0, len(results))
    for _, z := range results {
        symbol := z.Member.(string)
        stockData := getStockData(ctx, redisClient, symbol)
        if stockData != nil {
            stocks = append(stocks, *stockData)
        }
    }

    return stocks
}

func getAllIndexes(ctx context.Context, redisClient *redis.Client) []models.IndexData {
    keys, err := redisClient.Keys(ctx, "index:*").Result()
    if err != nil {
        log.Printf("Error fetching index keys: %v", err)
        return []models.IndexData{}
    }

    indexes := make([]models.IndexData, 0, len(keys))
    for _, key := range keys {
        indexId := key[6:]
        indexData := getIndexData(ctx, redisClient, indexId)
        if indexData != nil {
            indexes = append(indexes, *indexData)
        }
    }

    return indexes
}

func getDefaultIndexes(ctx context.Context, redisClient *redis.Client) []models.IndexData {
    // Updated to use standardized index symbols
    indexSymbols := []string{"VNIndex", "VN30", "HNXIndex"}
    indexes := make([]models.IndexData, 0, len(indexSymbols))
    for _, symbol := range indexSymbols {
        indexData := getIndexData(ctx, redisClient, symbol)
        if indexData != nil {
            indexes = append(indexes, *indexData)
        }
    }
    return indexes
}

func getStockData(ctx context.Context, redisClient *redis.Client, symbol string) *models.StockData {
    key := "stock:" + symbol
    data, err := redisClient.HGetAll(ctx, key).Result()
    if err != nil || len(data) == 0 {
        return nil
    }

    price, _ := strconv.ParseFloat(data["Price"], 64)
    change, _ := strconv.ParseFloat(data["Change"], 64)
    ratioChange, _ := strconv.ParseFloat(data["RatioChange"], 64)
    volume, _ := strconv.ParseFloat(data["Volume"], 64)

    return &models.StockData{
        Symbol:      symbol,
        Price:       price,
        Change:      change,
        RatioChange: ratioChange,
        Volume:      volume,
    }
}

func getIndexData(ctx context.Context, redisClient *redis.Client, indexId string) *models.IndexData {
    key := "index:" + indexId
    data, err := redisClient.HGetAll(ctx, key).Result()
    if err != nil || len(data) == 0 {
        return nil
    }

    indexValue, _ := strconv.ParseFloat(data["IndexValue"], 64)
    change, _ := strconv.ParseFloat(data["Change"], 64)
    ratioChange, _ := strconv.ParseFloat(data["RatioChange"], 64)
    totalTrade, _ := strconv.ParseInt(data["TotalTrade"], 10, 64)
    totalQtty, _ := strconv.ParseInt(data["TotalQtty"], 10, 64)
    totalValue, _ := strconv.ParseFloat(data["TotalValue"], 64)

    return &models.IndexData{
        IndexId:     indexId,
        IndexValue:  indexValue,
        Change:      change,
        RatioChange: ratioChange,
        TotalTrade:  totalTrade,
        TotalQtty:   totalQtty,
        TotalValue:  totalValue,
    }
}

func GetStockDetail(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        symbol := c.Param("symbol")
        ctx := c.Request.Context()

        stockData := getStockData(ctx, redisClient, symbol)
        if stockData == nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "Stock not found"})
            return
        }

        c.JSON(http.StatusOK, stockData)
    }
}


// Fix for StockDetailWebSocket in main_market_handler.go
func StockDetailWebSocket(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        symbol := c.Param("symbol")
        conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
        if err != nil {
            log.Printf("Failed to set websocket upgrade: %v", err)
            return
        }
        defer conn.Close()

        ctx, cancel := context.WithCancel(c.Request.Context())
        defer cancel()

        updateChan := make(chan models.StockData, 100)

        go listenForStockUpdates(ctx, redisClient, symbol, updateChan)

        initialData := getStockData(ctx, redisClient, symbol)
        if initialData != nil {
            // Send initial data in the format Dart expects
            initialUpdate := gin.H{
                "Symbol": initialData.Symbol,           // Add Symbol field
                "Price": initialData.Price,             // Change from currentPrice
                "Change": initialData.Change,           // Change from priceChange
                "RatioChange": initialData.RatioChange, // Change from percentChange
                "Volume": initialData.Volume,
            }
            if err := conn.WriteJSON(initialUpdate); err != nil {
                log.Printf("Error sending initial data: %v", err)
                return
            }
        } else {
            log.Printf("No initial data found for symbol: %s", symbol)
        }

        for {
            select {
            case update := <-updateChan:
                // Convert to format expected by Dart StockDetailUpdate
                stockUpdate := gin.H{
                    "Symbol": update.Symbol,           // Add Symbol field
                    "Price": update.Price,             // Change from currentPrice
                    "Change": update.Change,           // Change from priceChange
                    "RatioChange": update.RatioChange, // Change from percentChange
                    "Volume": update.Volume,
                }
                if err := conn.WriteJSON(stockUpdate); err != nil {
                    log.Printf("Error writing to WebSocket: %v", err)
                    return
                }
            case <-ctx.Done():
                return
            }
        }
    }
}


func listenForStockUpdates(ctx context.Context, redisClient *redis.Client, symbol string, updateChan chan<- models.StockData) {
    pubsub := redisClient.Subscribe(ctx, "stock_updates")
    defer pubsub.Close()

    for {
        select {
        case msg := <-pubsub.Channel():
            var update models.StockData
            if err := json.Unmarshal([]byte(msg.Payload), &update); err != nil {
                log.Printf("Error unmarshaling stock update: %v", err)
                continue
            }
            if update.Symbol == symbol {
                updateChan <- update
            }
        case <-ctx.Done():
            return
        }
    }
}

func GetIndexDetail(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        indexId := c.Param("indexId")
        ctx := c.Request.Context()

        indexData := getIndexData(ctx, redisClient, indexId)
        if indexData == nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "Index not found"})
            return
        }

        c.JSON(http.StatusOK, indexData)
    }
}

func IndexDetailWebSocket(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        indexId := c.Param("indexId")
        conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
        if err != nil {
            log.Printf("Failed to set websocket upgrade: %v", err)
            return
        }
        defer conn.Close()

        ctx, cancel := context.WithCancel(c.Request.Context())
        defer cancel()

        updateChan := make(chan models.IndexData, 100)

        go listenForIndexUpdates(ctx, redisClient, indexId, updateChan)

        initialData := getIndexData(ctx, redisClient, indexId)
        if initialData != nil {
            // Send initial data in the format Dart expects
            initialUpdate := gin.H{
                "IndexId": initialData.IndexId,         // Add IndexId field
                "IndexValue": initialData.IndexValue,
                "Change": initialData.Change,
                "RatioChange": initialData.RatioChange,
                "TotalTrade": initialData.TotalTrade,
                "TotalQtty": initialData.TotalQtty,
                "TotalValue": initialData.TotalValue,
            }
            if err := conn.WriteJSON(initialUpdate); err != nil {
                log.Printf("Error sending initial data: %v", err)
                return
            }
        } else {
            log.Printf("No initial data found for index: %s", indexId)
        }

        for {
            select {
            case update := <-updateChan:
                // Convert to format expected by Dart IndexDetailUpdate
                indexUpdate := gin.H{
                    "IndexId": update.IndexId,         // Add IndexId field
                    "IndexValue": update.IndexValue,
                    "Change": update.Change,
                    "RatioChange": update.RatioChange,
                    "TotalTrade": update.TotalTrade,
                    "TotalQtty": update.TotalQtty,
                    "TotalValue": update.TotalValue,
                }
                if err := conn.WriteJSON(indexUpdate); err != nil {
                    log.Printf("Error writing to WebSocket: %v", err)
                    return
                }
            case <-ctx.Done():
                return
            }
        }
    }
}

func listenForIndexUpdates(ctx context.Context, redisClient *redis.Client, indexId string, updateChan chan<- models.IndexData) {
    pubsub := redisClient.Subscribe(ctx, "index_updates")
    defer pubsub.Close()

    for {
        select {
        case msg := <-pubsub.Channel():
            var update models.IndexData
            if err := json.Unmarshal([]byte(msg.Payload), &update); err != nil {
                log.Printf("Error unmarshaling index update: %v", err)
                continue
            }
            if update.IndexId == indexId {
                updateChan <- update
            }
        case <-ctx.Done():
            return
        }
    }
}

func SearchStocks(redisClient *redis.Client, dbConn *sql.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        query := c.Query("q")
        ctx := c.Request.Context()

        log.Printf("🔍 Search request for: '%s'", query)

        if query == "" {
            // Return all stocks if no query provided
            results, _ := getAllStocksFromRedis(ctx, redisClient, 0, 50)
            log.Printf("📊 Returning %d stocks (no query)", len(results))
            c.JSON(http.StatusOK, results)
            return
        }

        results, err := searchStocksInRedisAndDB(ctx, redisClient, dbConn, query)
        if err != nil {
            log.Printf("❌ Failed to search stocks: %v", err)
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to search stocks"})
            return
        }

        log.Printf("✅ Search completed, found %d results for '%s'", len(results), query)
        c.JSON(http.StatusOK, results)
    }
}

func searchStocksInRedisAndDB(ctx context.Context, redisClient *redis.Client, dbConn *sql.DB, query string) ([]models.StockData, error) {
    sqlQuery := `
        SELECT s.symbol, s.en_name
        FROM stocks s
        WHERE LOWER(s.symbol) LIKE LOWER($1) OR LOWER(s.en_name) LIKE LOWER($1)
    `
    rows, err := dbConn.QueryContext(ctx, sqlQuery, "%"+query+"%")
    if err != nil {
        log.Printf("Error querying database: %v", err)
        return nil, err
    }
    defer rows.Close()

    var results []models.StockData
    for rows.Next() {
        var symbol, enName string
        if err := rows.Scan(&symbol, &enName); err != nil {
            log.Printf("Error scanning row: %v", err)
            return nil, err
        }

        // Check if this stock exists in Redis
        if stockData := getStockData(ctx, redisClient, symbol); stockData != nil {
            results = append(results, *stockData)
        }
    }

    if err := rows.Err(); err != nil {
        log.Printf("Error after scanning rows: %v", err)
        return nil, err
    }

    return results, nil
}

func GetAllStocks(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx := c.Request.Context()
        offset, _ := strconv.Atoi(c.DefaultQuery("offset", "0"))
        limit := 50

        stocks, hasMore := getAllStocksFromRedis(ctx, redisClient, offset, limit)

        c.JSON(http.StatusOK, gin.H{
            "stocks": stocks,
            "hasMore": hasMore,
            "nextOffset": offset + len(stocks),
        })
    }
}

func getAllStocksFromRedis(ctx context.Context, redisClient *redis.Client, offset, limit int) ([]models.StockData, bool) {
    keys, err := redisClient.Keys(ctx, "stock:*").Result()
    if err != nil {
        log.Printf("Error fetching stock keys: %v", err)
        return []models.StockData{}, false
    }

    log.Printf("📊 Found %d stock keys in Redis", len(keys))

    symbols := make([]string, len(keys))
    for i, key := range keys {
        symbols[i] = strings.TrimPrefix(key, "stock:")
    }
    sort.Strings(symbols)

    totalStocks := len(symbols)
    endIndex := offset + limit
    hasMore := endIndex < totalStocks

    if endIndex > totalStocks {
        endIndex = totalStocks
    }

    var stocks []models.StockData
    for _, symbol := range symbols[offset:endIndex] {
        stockData := getStockData(ctx, redisClient, symbol)
        if stockData != nil {
            stocks = append(stocks, *stockData)
        }
    }

    log.Printf("✅ Returning %d stocks from Redis (hasMore: %v)", len(stocks), hasMore)
    return stocks, hasMore
}
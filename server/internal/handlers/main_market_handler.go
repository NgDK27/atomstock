package handlers

import (
    "context"
    "encoding/json"
    "net/http"
    "strconv"
    "log"
    "strings"
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

func GetMainMarketData(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx := c.Request.Context()
        category := c.Query("category")

        var response gin.H
        switch category {
        case "volume":
            response = gin.H{"topVolume": getTopN(ctx, redisClient, "top_volume", 30)}
        case "gainers":
            response = gin.H{"topGainers": getTopN(ctx, redisClient, "top_gainers", 30)}
        case "losers":
            response = gin.H{"topLosers": getTopN(ctx, redisClient, "top_losers", 30)}
        default:
            response = gin.H{
                "topVolume":  getTopN(ctx, redisClient, "top_volume", 3),
                "topGainers": getTopN(ctx, redisClient, "top_gainers", 3),
                "topLosers":  getTopN(ctx, redisClient, "top_losers", 3),
                "indexes":    getDefaultIndexes(ctx, redisClient),
            }
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

        category := c.Query("category")

        ctx, cancel := context.WithCancel(c.Request.Context())
        defer cancel()

        updateChan := make(chan interface{})

        go listenForMainMarketUpdates(ctx, redisClient, category, updateChan)

        initialData := getInitialData(ctx, redisClient, category)
        if err := conn.WriteJSON(initialData); err != nil {
            log.Printf("Error sending initial data: %v", err)
            return
        }

        for {
            select {
            case update := <-updateChan:
                if err := conn.WriteJSON(update); err != nil {
                    log.Printf("Error writing to WebSocket: %v", err)
                    return
                }
            case <-ctx.Done():
                return
            }
        }
    }
}

func listenForMainMarketUpdates(ctx context.Context, redisClient *redis.Client, category string, updateChan chan<- interface{}) {
    pubsub := redisClient.Subscribe(ctx, "stock_updates", "index_updates")
    defer pubsub.Close()

    for {
        select {
        case msg := <-pubsub.Channel():
            var update map[string]interface{}
            if err := json.Unmarshal([]byte(msg.Payload), &update); err != nil {
                log.Printf("Error unmarshaling update: %v", err)
                continue
            }

            switch category {
            case "volume", "gainers", "losers":
                if symbol, ok := update["Symbol"].(string); ok {
                    if isInTopN(ctx, redisClient, symbol, "top_"+category, 30) {
                        updateChan <- gin.H{"top_" + category: []map[string]interface{}{update}}
                    }
                }
            default:
                if symbol, ok := update["Symbol"].(string); ok {
                    for _, cat := range []string{"volume", "gainers", "losers"} {
                        if isInTopN(ctx, redisClient, symbol, "top_"+cat, 3) {
                            updateChan <- gin.H{"top_" + cat: []map[string]interface{}{update}}
                        }
                    }
                } else if indexId, ok := update["IndexId"].(string); ok {
                    if indexId == "VNIndex" || indexId == "VN30" {
                        updateChan <- gin.H{"index": []map[string]interface{}{update}}
                    }
                }
            }
        case <-ctx.Done():
            return
        }
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

        updateChan := make(chan models.StockData)

        go listenForStockUpdates(ctx, redisClient, symbol, updateChan)

        initialData := getStockData(ctx, redisClient, symbol)
        if err := conn.WriteJSON(initialData); err != nil {
            log.Printf("Error sending initial data: %v", err)
            return
        }

        for {
            select {
            case update := <-updateChan:
                if err := conn.WriteJSON(update); err != nil {
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

        updateChan := make(chan models.IndexData)

        go listenForIndexUpdates(ctx, redisClient, indexId, updateChan)

        initialData := getIndexData(ctx, redisClient, indexId)
        if err := conn.WriteJSON(initialData); err != nil {
            log.Printf("Error sending initial data: %v", err)
            return
        }

        for {
            select {
            case update := <-updateChan:
                if err := conn.WriteJSON(update); err != nil {
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

func SearchStocks(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        query := c.Query("q")
        ctx := c.Request.Context()

        results := searchStocksInRedis(ctx, redisClient, query)
        c.JSON(http.StatusOK, results)
    }
}

func searchStocksInRedis(ctx context.Context, redisClient *redis.Client, query string) []models.StockData {
    keys, _ := redisClient.Keys(ctx, "stock:*").Result()
    var results []models.StockData

    for _, key := range keys {
        symbol := strings.TrimPrefix(key, "stock:")
        if strings.Contains(strings.ToLower(symbol), strings.ToLower(query)) {
            stockData := getStockData(ctx, redisClient, symbol)
            if stockData != nil {
                results = append(results, *stockData)
            }
        }
    }

    return results
}

func getTopN(ctx context.Context, redisClient *redis.Client, key string, n int) []models.StockData {
    keys, _ := redisClient.Keys(ctx, "stock:*").Result()
    var stocks []models.StockData
    for _, key := range keys {
        stockData := getStockData(ctx, redisClient, key[6:])
        if stockData != nil && stockData.RatioChange != -100 {
            stocks = append(stocks, *stockData)
        }
    }

    sortStocks(stocks, key)

    if len(stocks) > n {
        return stocks[:n]
    }
    return stocks
}

func sortStocks(stocks []models.StockData, key string) {
    switch key {
    case "top_volume":
        sort.Slice(stocks, func(i, j int) bool {
            return stocks[i].Volume > stocks[j].Volume
        })
    case "top_gainers":
        sort.Slice(stocks, func(i, j int) bool {
            return stocks[i].RatioChange > stocks[j].RatioChange
        })
    case "top_losers":
        sort.Slice(stocks, func(i, j int) bool {
            return stocks[i].RatioChange < stocks[j].RatioChange
        })
    }
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

func getDefaultIndexes(ctx context.Context, redisClient *redis.Client) []models.IndexData {
    indexSymbols := []string{"VNIndex", "VN30"}
    var indexes []models.IndexData
    for _, symbol := range indexSymbols {
        indexData := getIndexData(ctx, redisClient, symbol)
        if indexData != nil {
            indexes = append(indexes, *indexData)
        }
    }
    return indexes
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

func getInitialData(ctx context.Context, redisClient *redis.Client, category string) gin.H {
    switch category {
    case "volume":
        return gin.H{"topVolume": getTopN(ctx, redisClient, "top_volume", 30)}
    case "gainers":
        return gin.H{"topGainers": getTopN(ctx, redisClient, "top_gainers", 30)}
    case "losers":
        return gin.H{"topLosers": getTopN(ctx, redisClient, "top_losers", 30)}
    default:
        return gin.H{
            "topVolume":  getTopN(ctx, redisClient, "top_volume", 3),
            "topGainers": getTopN(ctx, redisClient, "top_gainers", 3),
            "topLosers":  getTopN(ctx, redisClient, "top_losers", 3),
            "indexes":    getDefaultIndexes(ctx, redisClient),
        }
    }
}

func isInTopN(ctx context.Context, redisClient *redis.Client, symbol, key string, n int) bool {
    stocks := getTopN(ctx, redisClient, key, n)
    for _, stock := range stocks {
        if stock.Symbol == symbol {
            return true
        }
    }
    return false
}
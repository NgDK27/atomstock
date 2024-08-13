package handlers

import (
    "context"
    "fmt"
    "log"
    "net/http"
    "sort"
    "strconv"
    "strings"
    "time"

    "github.com/gin-gonic/gin"
    "github.com/gorilla/websocket"
    "github.com/redis/go-redis/v9"
    "oppenhomies/server/internal/models"
)

type MainMarketResponse struct {
    Version     int64               `json:"version"`
    TopVolume   []models.StockData  `json:"topVolume"`
    TopIncrease []models.StockData  `json:"topIncrease"`
    TopDecrease []models.StockData  `json:"topDecrease"`
    Indexes     []models.IndexData  `json:"indexes"`
}

var upgrader = websocket.Upgrader{
    ReadBufferSize:  1024,
    WriteBufferSize: 1024,
    CheckOrigin: func(r *http.Request) bool {
        return true
    },
}

func GetMainMarketData(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        ctx := c.Request.Context()

        response, err := fetchMainMarketData(ctx, redisClient)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        c.JSON(http.StatusOK, response)
    }
}

func MainMarketWebSocket(redisClient *redis.Client) gin.HandlerFunc {
    return func(c *gin.Context) {
        conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
        if err != nil {
            log.Println("Failed to set websocket upgrade:", err)
            return
        }
        defer conn.Close()

        ctx, cancel := context.WithCancel(c.Request.Context())
        defer cancel()

        // Send initial data
        initialData, err := fetchMainMarketData(ctx, redisClient)
        if err != nil {
            log.Println("Error fetching initial data:", err)
            return
        }
        if err := conn.WriteJSON(initialData); err != nil {
            log.Println("Error sending initial data:", err)
            return
        }

        // Create a list of symbols to watch
        watchSymbols := make(map[string]bool)
        for _, stock := range initialData.TopVolume {
            watchSymbols[stock.Symbol] = true
        }
        for _, stock := range initialData.TopIncrease {
            watchSymbols[stock.Symbol] = true
        }
        for _, stock := range initialData.TopDecrease {
            watchSymbols[stock.Symbol] = true
        }
        for _, index := range initialData.Indexes {
            watchSymbols[index.IndexId] = true
        }

        // Subscribe to Redis pubsub for watched symbols
        patterns := make([]string, 0, len(watchSymbols))
        for symbol := range watchSymbols {
            patterns = append(patterns, fmt.Sprintf("stock:%s", symbol), fmt.Sprintf("index:%s", symbol))
        }
        pubsub := redisClient.PSubscribe(ctx, patterns...)
        defer pubsub.Close()

        // Start goroutine to listen for Redis messages
        go func() {
            for {
                select {
                case msg := <-pubsub.Channel():
                    // Process the message
                    updatedData, err := processRedisMessage(ctx, redisClient, msg, initialData)
                    if err != nil {
                        log.Println("Error processing Redis message:", err)
                        continue
                    }
                    if updatedData != nil {
                        if err := conn.WriteJSON(updatedData); err != nil {
                            log.Println("Error sending updated data:", err)
                            return
                        }
                    }
                case <-ctx.Done():
                    return
                }
            }
        }()

        // Keep the connection alive
        for {
            _, _, err := conn.ReadMessage()
            if err != nil {
                log.Println("Error reading message:", err)
                return
            }

        }
    }
}

func processRedisMessage(ctx context.Context, redisClient *redis.Client, msg *redis.Message, currentData *MainMarketResponse) (*MainMarketResponse, error) {
    key := msg.Channel
    var updatedData *MainMarketResponse

    if strings.HasPrefix(key, "stock:") {
        stockData, err := fetchStockData(ctx, redisClient, key)
        if err != nil {
            return nil, err
        }
        updatedData = updateStockInResponse(currentData, stockData)
    } else if strings.HasPrefix(key, "index:") {
        indexData, err := fetchIndexData(ctx, redisClient, key)
        if err != nil {
            return nil, err
        }
        updatedData = updateIndexInResponse(currentData, indexData)
    }

    if updatedData != nil {
        updatedData.Version++
    }

    return updatedData, nil
}

func updateStockInResponse(currentData *MainMarketResponse, stockData *models.StockData) *MainMarketResponse {
    updated := false
    newData := *currentData

    updated = updateListIfPresent(&newData.TopVolume, stockData) || updated
    updated = updateListIfPresent(&newData.TopIncrease, stockData) || updated
    updated = updateListIfPresent(&newData.TopDecrease, stockData) || updated

    if updated {
        return &newData
    }
    return nil
}

func updateListIfPresent(list *[]models.StockData, stockData *models.StockData) bool {
    for i, stock := range *list {
        if stock.Symbol == stockData.Symbol {
            (*list)[i] = *stockData
            return true
        }
    }
    return false
}

func updateIndexInResponse(currentData *MainMarketResponse, indexData *models.IndexData) *MainMarketResponse {
    for i, index := range currentData.Indexes {
        if index.IndexId == indexData.IndexId {
            newData := *currentData
            newData.Indexes[i] = *indexData
            return &newData
        }
    }
    return nil
}

func fetchMainMarketData(ctx context.Context, redisClient *redis.Client) (*MainMarketResponse, error) {
    // Fetch all stock data from Redis
    keys, err := redisClient.Keys(ctx, "stock:*").Result()
    if err != nil {
        return nil, err
    }

    var allStocks []models.StockData
    for _, key := range keys {
        data, err := redisClient.HGetAll(ctx, key).Result()
        if err != nil {
            continue
        }

        ratioChange := parseFloat(data["RatioChange"])
        if ratioChange == -100 {
            continue
        }

        stock := models.StockData{
            Symbol:      key[6:], // Remove "stock:" prefix
            Price:       parseFloat(data["Price"]),
            Change:      parseFloat(data["Change"]),
            RatioChange: ratioChange,
            Volume:      parseFloat(data["Volume"]),
        }
        allStocks = append(allStocks, stock)
    }

    // Sort stocks
    topVolume := make([]models.StockData, len(allStocks))
    copy(topVolume, allStocks)
    sort.Slice(topVolume, func(i, j int) bool {
        return topVolume[i].Volume > topVolume[j].Volume
    })
    topVolume = topVolume[:min(3, len(topVolume))]

    topIncrease := make([]models.StockData, len(allStocks))
    copy(topIncrease, allStocks)
    sort.Slice(topIncrease, func(i, j int) bool {
        return topIncrease[i].RatioChange > topIncrease[j].RatioChange
    })
    topIncrease = topIncrease[:min(3, len(topIncrease))]

    topDecrease := make([]models.StockData, len(allStocks))
    copy(topDecrease, allStocks)
    sort.Slice(topDecrease, func(i, j int) bool {
        return topDecrease[i].RatioChange < topDecrease[j].RatioChange
    })
    topDecrease = topDecrease[:min(3, len(topDecrease))]

    // Fetch index data
    indexSymbols := []string{"VNIndex", "VN30"}
    var indexes []models.IndexData
    for _, symbol := range indexSymbols {
        data, err := redisClient.HGetAll(ctx, "index:"+symbol).Result()
        if err != nil {
            continue
        }

        index := models.IndexData{
            IndexId:     symbol,
            IndexValue:  parseFloat(data["IndexValue"]),
            Change:      parseFloat(data["Change"]),
            RatioChange: parseFloat(data["RatioChange"]),
        }
        indexes = append(indexes, index)
    }

    response := &MainMarketResponse{
        Version:     time.Now().UnixNano(),
        TopVolume:   topVolume,
        TopIncrease: topIncrease,
        TopDecrease: topDecrease,
        Indexes:     indexes,
    }

    return response, nil
}

func fetchStockData(ctx context.Context, redisClient *redis.Client, key string) (*models.StockData, error) {
    data, err := redisClient.HGetAll(ctx, key).Result()
    if err != nil {
        return nil, err
    }

    ratioChange := parseFloat(data["RatioChange"])
    if ratioChange == -100 {
        return nil, fmt.Errorf("stock with RatioChange -100 is excluded")
    }

    return &models.StockData{
        Symbol:      key[6:], // Remove "stock:" prefix
        Price:       parseFloat(data["Price"]),
        Change:      parseFloat(data["Change"]),
        RatioChange: ratioChange,
        Volume:      parseFloat(data["Volume"]),
    }, nil
}

func fetchIndexData(ctx context.Context, redisClient *redis.Client, key string) (*models.IndexData, error) {
    data, err := redisClient.HGetAll(ctx, key).Result()
    if err != nil {
        return nil, err
    }

    return &models.IndexData{
        IndexId:     key[6:], // Remove "index:" prefix
        IndexValue:  parseFloat(data["IndexValue"]),
        Change:      parseFloat(data["Change"]),
        RatioChange: parseFloat(data["RatioChange"]),
    }, nil
}

func parseFloat(s string) float64 {
    f, _ := strconv.ParseFloat(s, 64)
    return f
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
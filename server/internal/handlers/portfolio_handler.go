package handlers

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "log"
    "oppenhomies/server/internal/services"
)

func GetPortfolio(portfolioService *services.PortfolioService) gin.HandlerFunc {
    return func(c *gin.Context) {
        userID, _ := c.Get("userID")
        portfolio, err := portfolioService.GetPortfolio(userID.(string))
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch portfolio"})
            return
        }
        c.JSON(http.StatusOK, portfolio)
    }
}


func PortfolioWebSocket(portfolioService *services.PortfolioService) gin.HandlerFunc {
    return func(c *gin.Context) {
        userID, _ := c.Get("userID")
        conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
        if err != nil {
            log.Printf("Failed to set websocket upgrade: %v", err)
            return
        }
        defer conn.Close()

        portfolioService.SubscribeToUpdates(userID.(string), conn)

        for {
            _, _, err := conn.ReadMessage()
            if err != nil {
                log.Printf("Error reading message: %v", err)
                break
            }
        }

        portfolioService.UnsubscribeFromUpdates(userID.(string), conn)
    }
}
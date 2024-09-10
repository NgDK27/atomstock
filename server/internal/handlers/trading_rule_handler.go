package handlers

import (
    "net/http"
    "strconv"
	"database/sql"
    "time"

    "github.com/gin-gonic/gin"
    "oppenhomies/server/internal/models"
)


func ListTradingRules(db *sql.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        userID, _ := c.Get("userID")

        rows, err := db.Query("SELECT * FROM trading_rules WHERE user_id = $1", userID)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch trading rules"})
            return
        }
        defer rows.Close()

        var rules []models.TradingRule
        for rows.Next() {
            var rule models.TradingRule
            err := rows.Scan(&rule.ID, &rule.UserID, &rule.Symbol, &rule.Shares, &rule.EntryConditionType,
                &rule.EntryTriggerValue, &rule.EntryRangeType, &rule.TrailingStopLossPercentage, 
                &rule.TakeProfitPercentage, &rule.IsActive, &rule.CreatedAt)
            if err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse trading rules"})
                return
            }
            rules = append(rules, rule)
        }

        c.JSON(http.StatusOK, rules)
    }
}

// Helper function to get total rule value for a user
func getTotalRuleValue(db *sql.DB, userID string, excludeRuleID int64) (float64, error) {
    query := `
        SELECT COALESCE(SUM(shares * entry_trigger_value), 0)
        FROM trading_rules
        WHERE user_id = $1 AND is_active = true
    `
    args := []interface{}{userID}

    if excludeRuleID > 0 {
        query += " AND id != $2"
        args = append(args, excludeRuleID)
    }

    var totalValue float64
    err := db.QueryRow(query, args...).Scan(&totalValue)
    return totalValue, err
}

func CreateTradingRule(db *sql.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var rule models.TradingRule
        if err := c.ShouldBindJSON(&rule); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }

        userID, _ := c.Get("userID")
        rule.UserID = userID.(string)

        // Get user's balance
        var balance float64
        err := db.QueryRow("SELECT balance FROM users WHERE id = $1", userID).Scan(&balance)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch user balance"})
            return
        }

        // Calculate total value of existing rules
        totalRuleValue, err := getTotalRuleValue(db, rule.UserID, 0)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to calculate existing rule values"})
            return
        }

        // Check if new rule would exceed balance
        newRuleValue := float64(rule.Shares) * rule.EntryTriggerValue
        if totalRuleValue + newRuleValue > balance {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Creating this rule would exceed your available balance"})
            return
        }

        // Insert new rule
        err = db.QueryRow(`
            INSERT INTO trading_rules (
                user_id, symbol, shares, entry_condition_type, entry_trigger_value, 
                entry_range_type, trailing_stop_loss_percentage, take_profit_percentage, is_active, created_at
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
            RETURNING id, is_active, created_at`,
            rule.UserID, rule.Symbol, rule.Shares, rule.EntryConditionType, rule.EntryTriggerValue,
            rule.EntryRangeType, rule.TrailingStopLossPercentage, rule.TakeProfitPercentage, true, time.Now()).Scan(&rule.ID, &rule.IsActive, &rule.CreatedAt)

        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        c.JSON(http.StatusCreated, rule)
    }
}

func getCurrentRuleDetails(db *sql.DB, ruleID int64, userID string) (models.TradingRule, error) {
    var rule models.TradingRule
    err := db.QueryRow(`
        SELECT id, user_id, symbol, shares, entry_condition_type, entry_trigger_value, 
               entry_range_type, trailing_stop_loss_percentage, take_profit_percentage, is_active
        FROM trading_rules 
        WHERE id = $1 AND user_id = $2`, ruleID, userID).Scan(
        &rule.ID, &rule.UserID, &rule.Symbol, &rule.Shares, &rule.EntryConditionType, 
        &rule.EntryTriggerValue, &rule.EntryRangeType, &rule.TrailingStopLossPercentage, 
        &rule.TakeProfitPercentage, &rule.IsActive)
    return rule, err
}

func UpdateTradingRule(db *sql.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        id, err := strconv.ParseInt(c.Param("id"), 10, 64)
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid rule ID"})
            return
        }

        // Check for trade associated with this rule
        var openTradesCount int
        err = db.QueryRow("SELECT COUNT(*) FROM trades WHERE rule_id = $1", id).Scan(&openTradesCount)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check for trade"})
            return
        }

        if openTradesCount > 0 {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot update rule that has trade"})
            return
        }

        // Update if there are no trade
        var updatedRule models.TradingRule
        if err := c.ShouldBindJSON(&updatedRule); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }

        userID, _ := c.Get("userID")
        updatedRule.UserID = userID.(string)

        // Get current rule details
        currentRule, err := getCurrentRuleDetails(db, id, updatedRule.UserID)
        if err != nil {
            if err == sql.ErrNoRows {
                c.JSON(http.StatusNotFound, gin.H{"error": "Trading rule not found"})
            } else {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch current rule details"})
            }
            return
        }

        // Get user's balance
        var balance float64
        err = db.QueryRow("SELECT balance FROM users WHERE id = $1", userID).Scan(&balance)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch user balance"})
            return
        }

        // Calculate total value of existing rules (including this rule)
        totalRuleValue, err := getTotalRuleValue(db, updatedRule.UserID, 0)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to calculate existing rule values"})
            return
        }

        // Calculate the difference in rule value
        currentRuleValue := float64(currentRule.Shares) * currentRule.EntryTriggerValue
        updatedRuleValue := float64(updatedRule.Shares) * updatedRule.EntryTriggerValue
        valueDifference := updatedRuleValue - currentRuleValue

        // Check if updated rule would exceed balance
        if totalRuleValue + valueDifference > balance {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Updating this rule would exceed your available balance"})
            return
        }

        // Update the rule
        _, err = db.Exec(`
            UPDATE trading_rules 
            SET shares = $1, entry_condition_type = $2, entry_trigger_value = $3, 
                entry_range_type = $4, trailing_stop_loss_percentage = $5, 
                take_profit_percentage = $6, is_active = $7
            WHERE id = $8 AND user_id = $9`,
            updatedRule.Shares, updatedRule.EntryConditionType, updatedRule.EntryTriggerValue,
            updatedRule.EntryRangeType, updatedRule.TrailingStopLossPercentage, 
            updatedRule.TakeProfitPercentage, updatedRule.IsActive,
            id, userID)

        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update trading rule"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Trading rule updated successfully"})
    }
}

func DeleteTradingRule(db *sql.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        id, err := strconv.Atoi(c.Param("id"))
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid rule ID"})
            return
        }

        userID, _ := c.Get("userID")

        // Check for trade associated with this rule
        var openTradesCount int
        err = db.QueryRow("SELECT COUNT(*) FROM trades WHERE rule_id = $1", id).Scan(&openTradesCount)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check for trade"})
            return
        }

        if openTradesCount > 0 {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot delete rule with trade"})
            return
        }

        // Delete if there are no trades
        _, err = db.Exec("DELETE FROM trading_rules WHERE id = $1 AND user_id = $2", id, userID)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete trading rule"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Trading rule deleted successfully"})
    }
}
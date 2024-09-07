package models

import "time"

type TradingRule struct {
	ID                         int       `json:"id"`
	UserID                     string    `json:"user_id"`
	Symbol                     string    `json:"symbol"`
	Shares                     int       `json:"shares"`
	EntryConditionType         string    `json:"entry_condition_type"`
	EntryTriggerValue          float64   `json:"entry_trigger_value"`
	EntryRangeType             string    `json:"entry_range_type"`
	TrailingStopLossPercentage float64   `json:"trailing_stop_loss_percentage"`
	TakeProfitPercentage       float64   `json:"take_profit_percentage"`
	IsActive                   bool      `json:"is_active"`
	CreatedAt                  time.Time `json:"created_at"`
}
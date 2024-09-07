package models

import "time"

type Trade struct {
	ID              int       `json:"id"`
	RuleID          int       `json:"rule_id"`
	UserID          string    `json:"user_id"`
	Symbol          string    `json:"symbol"`
	EntryPrice      float64   `json:"entry_price"`
	HighestPrice	float64   `json:"highest_price"`
	EntryTime       time.Time `json:"entry_time"`
	Shares          int       `json:"shares"`
	ExitPrice       float64   `json:"exit_price,omitempty"`
	ExitTime        time.Time `json:"exit_time,omitempty"`
	ExitType        string    `json:"exit_type,omitempty"`
	Status          string    `json:"status"`
	TakeProfitPrice float64   `json:"take_profit_price"`
}

type TradeExecution struct {
	UserID    string    `json:"user_id"`
	Symbol    string    `json:"symbol"`
	Shares    int       `json:"shares"`
	EntryPrice float64   `json:"entry_price,omitempty"`
	EntryTime  time.Time `json:"entry_time,omitempty"`
	ExitPrice  float64   `json:"exit_price,omitempty"`
	ExitTime   time.Time `json:"exit_time,omitempty"`
	ExitType   string    `json:"exit_type,omitempty"`
}
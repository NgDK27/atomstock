package models

import "time"

type Portfolio struct {
	ID          int       `json:"id"`
	UserID      string    `json:"user_id"`
	TotalValue  float64   `json:"total_value"`
	LastUpdated time.Time `json:"last_updated"`
	Positions   []PortfolioPosition `json:"positions,omitempty"`
}

type PortfolioPosition struct {
	Symbol       string  `json:"symbol"`
	Shares       int     `json:"shares"`
	Price        float64 `json:"price"`
	CurrentPrice float64 `json:"current_price"`
	Value        float64 `json:"value"`
}

type PortfolioUpdate struct {
	UserID     string    `json:"user_id"`
	TotalValue float64   `json:"total_value"`
	UpdateTime time.Time `json:"update_time"`
}
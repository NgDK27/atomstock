package models

type StockData struct {
    Symbol        string  `json:"Symbol"`
    RefPrice      float64 `json:"RefPrice"`
    Ceiling       float64 `json:"Ceiling"`
    Floor         float64 `json:"Floor"`
    Price         float64 `json:"Price"`
    Change        float64 `json:"Change"`
    RatioChange   float64 `json:"RatioChange"`
    Open          float64 `json:"Open"`
    High          float64 `json:"High"`
    Low           float64 `json:"Low"`
    Volume        int64   `json:"Volume"`
    TotalVal      float64 `json:"TotalVal"`
    TradingTime   string  `json:"Time"`
    TradingDate   string  `json:"TradingDate"`
    TradingStatus string  `json:"TradingStatus"`
}
package models

type StockData struct {
    Symbol        string  `json:"Symbol"`
    Price         float64 `json:"Price"`
    Change        float64 `json:"Change"`
    RatioChange   float64 `json:"RatioChange"`
    Volume        float64 `json:"Volume"`
}
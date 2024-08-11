package models

type IndexData struct {
    IndexId       string  `json:"IndexId"`
    IndexValue    float64 `json:"IndexValue"`
    Change        float64 `json:"Change"`
    RatioChange   float64 `json:"RatioChange"`
    TotalTrade    int64   `json:"TotalTrade"`
    TotalQtty     int64   `json:"TotalQtty"`
    TotalValue    float64 `json:"TotalValue"`
}
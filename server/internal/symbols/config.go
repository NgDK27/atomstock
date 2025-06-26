// server/internal/symbols/config.go
// Centralized configuration for Vietnamese stock symbols
// This ensures consistency across producer, consumer, and API (matches symbols_config.py)

package symbols

// StockInfo represents stock information
type StockInfo struct {
	Symbol string
	Name   string
	Market string
}

// IndexInfo represents index information
type IndexInfo struct {
	Symbol string
	Market string
}

// Major Vietnamese Stock Indexes
var VietnameseIndexes = []IndexInfo{
	// HOSE indexes
	{"VNIndex", "HOSE"},      // Ho Chi Minh Stock Exchange Index
	{"VN30", "HOSE"},         // VN30 Index (Top 30 companies)
	{"VNMidCap", "HOSE"},     // VN MidCap Index
	{"VNSmallCap", "HOSE"},   // VN SmallCap Index
	{"VNAllShare", "HOSE"},   // VN AllShare Index
	// HNX indexes
	{"HNXIndex", "HNX"},      // Hanoi Stock Exchange Index
	{"HNX30", "HNX"},         // HNX30 Index
	{"HNXCon", "HNX"},        // HNX Construction Index
	{"HNXFin", "HNX"},        // HNX Finance Index
	{"HNXLCap", "HNX"},       // HNX Large Cap Index
	{"HNXMSci", "HNX"},       // HNX Manufacturing & Science Index
	// UPCOM index
	{"UpcomIndex", "UPCOM"},  // UPCoM Index
}

// Top 50 Vietnamese Stocks (Major companies across sectors)
var VietnameseStocks = []StockInfo{
	// Banking & Finance (VN30 Banks)
	{"VCB", "Vietcombank", "HOSE"},
	{"BID", "BIDV", "HOSE"},
	{"CTG", "VietinBank", "HOSE"},
	{"TCB", "Techcombank", "HOSE"},
	{"ACB", "Asia Commercial Bank", "HOSE"},
	{"MBB", "Military Bank", "HOSE"},
	{"STB", "Sacombank", "HOSE"},
	{"VPB", "VPBank", "HOSE"},
	{"TPB", "Tien Phong Bank", "HOSE"},
	{"EIB", "Eximbank", "HOSE"},
	
	// Real Estate & Construction
	{"VIC", "Vingroup", "HOSE"},
	{"VHM", "Vinhomes", "HOSE"},
	{"VRE", "Vincom Retail", "HOSE"},
	{"BCM", "Becamex IDC", "HOSE"},
	{"KDH", "Khang Dien House", "HOSE"},
	{"NVL", "Novaland", "HOSE"},
	{"PDR", "Phat Dat Real Estate", "HOSE"},
	{"DXG", "Dat Xanh Group", "HOSE"},
	
	// Manufacturing & Heavy Industry
	{"HPG", "Hoa Phat Group", "HOSE"},
	{"HSG", "Hoa Sen Group", "HOSE"},
	{"NKG", "Nam Kim Group", "HOSE"},
	{"POM", "Pomina Steel", "HOSE"},
	{"TVN", "Vietnam Tanker", "HOSE"},
	
	// Consumer Goods & Food
	{"VNM", "Vinamilk", "HOSE"},
	{"MSN", "Masan Group", "HOSE"},
	{"SAB", "Sabeco", "HOSE"},
	{"BHN", "Bien Hoa Sugar", "HOSE"},
	{"KDC", "Kinh Do Corporation", "HOSE"},
	{"MCH", "Masan Consumer Holdings", "HOSE"},
	
	// Technology & Telecommunications
	{"FPT", "FPT Corporation", "HOSE"},
	{"CMG", "CMC Corporation", "HOSE"},
	{"ELC", "Electronics Corporation", "HOSE"},
	{"ITD", "IT&T Development", "HOSE"},
	
	// Energy & Utilities
	{"GAS", "PetroVietnam Gas", "HOSE"},
	{"PLX", "Petrolimex", "HOSE"},
	{"POW", "PetroVietnam Power", "HOSE"},
	{"REE", "Refrigeration Electrical Engineering", "HOSE"},
	{"NT2", "Nam Theun 2 Power", "HOSE"},
	
	// Healthcare & Pharmaceuticals
	{"DHG", "Hau Giang Pharmaceutical", "HOSE"},
	{"IMP", "Imexpharm", "HOSE"},
	{"PME", "Petrovietnam Medical", "HOSE"},
	
	// Transportation & Logistics
	{"VJC", "VietJet Aviation", "HOSE"},
	{"HVN", "Vietnam Airlines", "HOSE"},
	{"GMD", "Gemadept Corporation", "HOSE"},
	{"PVT", "PetroVietnam Transportation", "HOSE"},
	
	// Retail & Services
	{"MWG", "Mobile World Group", "HOSE"},
	{"FRT", "FPT Retail", "HOSE"},
	{"PNJ", "Phu Nhuan Jewelry", "HOSE"},
	{"SBT", "Saigon Beer Alcohol Beverage", "HOSE"},
}

// GetAllSymbols returns all configured symbols
func GetAllSymbols() ([]StockInfo, []IndexInfo) {
	return VietnameseStocks, VietnameseIndexes
}

// GetStockSymbols returns only stock symbols as strings
func GetStockSymbols() []string {
	symbols := make([]string, len(VietnameseStocks))
	for i, stock := range VietnameseStocks {
		symbols[i] = stock.Symbol
	}
	return symbols
}

// GetIndexSymbols returns only index symbols as strings
func GetIndexSymbols() []string {
	symbols := make([]string, len(VietnameseIndexes))
	for i, index := range VietnameseIndexes {
		symbols[i] = index.Symbol
	}
	return symbols
}

// IsValidSymbol checks if a symbol is in our configured list
func IsValidSymbol(symbol string) bool {
	for _, stock := range VietnameseStocks {
		if stock.Symbol == symbol {
			return true
		}
	}
	for _, index := range VietnameseIndexes {
		if index.Symbol == symbol {
			return true
		}
	}
	return false
}

// GetSymbolInfo returns information about a specific symbol
func GetSymbolInfo(symbol string) (*StockInfo, *IndexInfo) {
	// Check stocks first
	for _, stock := range VietnameseStocks {
		if stock.Symbol == symbol {
			return &stock, nil
		}
	}
	
	// Check indexes
	for _, index := range VietnameseIndexes {
		if index.Symbol == symbol {
			return nil, &index
		}
	}
	
	return nil, nil
}

// GetSymbolsByMarket returns symbols filtered by market
func GetSymbolsByMarket(market string) ([]StockInfo, []IndexInfo) {
	var stocks []StockInfo
	var indexes []IndexInfo
	
	for _, stock := range VietnameseStocks {
		if stock.Market == market {
			stocks = append(stocks, stock)
		}
	}
	
	for _, index := range VietnameseIndexes {
		if index.Market == market {
			indexes = append(indexes, index)
		}
	}
	
	return stocks, indexes
}

// GetTotalSymbolCount returns the total number of configured symbols
func GetTotalSymbolCount() int {
	return len(VietnameseStocks) + len(VietnameseIndexes)
}

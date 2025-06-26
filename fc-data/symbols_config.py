# symbols_config.py
# Centralized configuration for Vietnamese stock symbols
# This ensures consistency across producer, consumer, and API

# Major Vietnamese Stock Indexes with realistic base values
VIETNAMESE_INDEXES = [
    ('VNIndex', 'HOSE', 1250.0),      # Ho Chi Minh Stock Exchange Index
    ('VN30', 'HOSE', 1450.0),         # VN30 Index (Top 30 companies)
    ('VNMidCap', 'HOSE', 890.0),      # VN MidCap Index
    ('VNSmallCap', 'HOSE', 520.0),    # VN SmallCap Index
    ('VNAllShare', 'HOSE', 1180.0),   # VN AllShare Index
    ('HNXIndex', 'HNX', 245.0),       # Hanoi Stock Exchange Index
    ('HNX30', 'HNX', 380.0),          # HNX30 Index
    ('HNXCon', 'HNX', 165.0),         # HNX Construction Index
    ('HNXFin', 'HNX', 290.0),         # HNX Finance Index
    ('HNXLCap', 'HNX', 320.0),        # HNX Large Cap Index
    ('HNXMSci', 'HNX', 195.0),        # HNX Manufacturing & Science Index
    ('UpcomIndex', 'UPCOM', 85.0),    # UPCoM Index
]

# Top Vietnamese Stocks with realistic base prices (in VND)
VIETNAMESE_STOCKS = [
    # Banking & Finance (VN30 Banks) - Higher prices for major banks
    ('VCB', 'Vietcombank', 'HOSE', 82500.0),
    ('BID', 'BIDV', 'HOSE', 45800.0),
    ('CTG', 'VietinBank', 'HOSE', 38200.0),
    ('TCB', 'Techcombank', 'HOSE', 28900.0),
    ('ACB', 'Asia Commercial Bank', 'HOSE', 24600.0),
    ('MBB', 'Military Bank', 'HOSE', 22400.0),
    ('STB', 'Sacombank', 'HOSE', 18750.0),
    ('VPB', 'VPBank', 'HOSE', 16200.0),
    ('TPB', 'Tien Phong Bank', 'HOSE', 26800.0),
    ('EIB', 'Eximbank', 'HOSE', 19400.0),

    # Real Estate & Construction - Premium stocks
    ('VIC', 'Vingroup', 'HOSE', 65800.0),
    ('VHM', 'Vinhomes', 'HOSE', 58200.0),
    ('VRE', 'Vincom Retail', 'HOSE', 32500.0),
    ('BCM', 'Becamex IDC', 'HOSE', 28400.0),
    ('KDH', 'Khang Dien House', 'HOSE', 34600.0),
    ('NVL', 'Novaland', 'HOSE', 12800.0),
    ('PDR', 'Phat Dat Real Estate', 'HOSE', 25700.0),
    ('DXG', 'Dat Xanh Group', 'HOSE', 19200.0),

    # Manufacturing & Heavy Industry
    ('HPG', 'Hoa Phat Group', 'HOSE', 24800.0),
    ('HSG', 'Hoa Sen Group', 'HOSE', 15600.0),
    ('NKG', 'Nam Kim Group', 'HOSE', 42300.0),
    ('POM', 'Pomina Steel', 'HOSE', 18900.0),
    ('TVN', 'Vietnam Tanker', 'HOSE', 22100.0),

    # Consumer Goods & Food - Stable high-value stocks
    ('VNM', 'Vinamilk', 'HOSE', 76500.0),
    ('MSN', 'Masan Group', 'HOSE', 98200.0),
    ('SAB', 'Sabeco', 'HOSE', 156000.0),
    ('BHN', 'Bien Hoa Sugar', 'HOSE', 14200.0),
    ('KDC', 'Kinh Do Corporation', 'HOSE', 35800.0),
    ('MCH', 'Masan Consumer Holdings', 'HOSE', 67400.0),

    # Technology & Telecommunications
    ('FPT', 'FPT Corporation', 'HOSE', 89600.0),
    ('CMG', 'CMC Corporation', 'HOSE', 28500.0),
    ('ELC', 'Electronics Corporation', 'HOSE', 22800.0),
    ('ITD', 'IT&T Development', 'HOSE', 18700.0),

    # Energy & Utilities - Mid-range prices
    ('GAS', 'PetroVietnam Gas', 'HOSE', 125000.0),
    ('PLX', 'Petrolimex', 'HOSE', 54200.0),
    ('POW', 'PetroVietnam Power', 'HOSE', 38600.0),
    ('REE', 'Refrigeration Electrical Engineering', 'HOSE', 68900.0),
    ('NT2', 'Nam Theun 2 Power', 'HOSE', 26400.0),

    # Healthcare & Pharmaceuticals
    ('DHG', 'Hau Giang Pharmaceutical', 'HOSE', 42800.0),
    ('IMP', 'Imexpharm', 'HOSE', 78900.0),
    ('PME', 'Petrovietnam Medical', 'HOSE', 32100.0),

    # Transportation & Logistics
    ('VJC', 'VietJet Aviation', 'HOSE', 112000.0),
    ('HVN', 'Vietnam Airlines', 'HOSE', 18600.0),
    ('GMD', 'Gemadept Corporation', 'HOSE', 46200.0),
    ('PVT', 'PetroVietnam Transportation', 'HOSE', 29800.0),

    # Retail & Services
    ('MWG', 'Mobile World Group', 'HOSE', 48500.0),
    ('FRT', 'FPT Retail', 'HOSE', 72300.0),
    ('PNJ', 'Phu Nhuan Jewelry', 'HOSE', 95600.0),
    ('SBT', 'Saigon Beer Alcohol Beverage', 'HOSE', 58700.0),
]

def get_all_symbols():
    """
    Get all configured symbols for Vietnamese market
    Returns: tuple of (stocks, indexes)
    """
    return VIETNAMESE_STOCKS, VIETNAMESE_INDEXES

def get_stock_symbols():
    """Get only stock symbols"""
    return VIETNAMESE_STOCKS

def get_index_symbols():
    """Get only index symbols"""
    return VIETNAMESE_INDEXES

def is_valid_symbol(symbol):
    """Check if a symbol is in our configured list"""
    stock_symbols = [s[0] for s in VIETNAMESE_STOCKS]
    index_symbols = [i[0] for i in VIETNAMESE_INDEXES]
    return symbol in stock_symbols or symbol in index_symbols

def get_symbol_info(symbol):
    """Get information about a specific symbol"""
    # Check stocks first
    for stock in VIETNAMESE_STOCKS:
        if stock[0] == symbol:
            return {
                'type': 'stock',
                'symbol': stock[0],
                'name': stock[1],
                'market': stock[2],
                'base_price': stock[3]
            }

    # Check indexes
    for index in VIETNAMESE_INDEXES:
        if index[0] == symbol:
            return {
                'type': 'index',
                'symbol': index[0],
                'market': index[1],
                'base_value': index[2]
            }

    return None

def get_base_price(symbol):
    """Get the base price for a symbol"""
    symbol_info = get_symbol_info(symbol)
    if symbol_info:
        if symbol_info['type'] == 'stock':
            return symbol_info['base_price']
        else:
            return symbol_info['base_value']
    return None

# For backward compatibility
def get_symbols():
    """Legacy function name - returns stocks and indexes"""
    return get_all_symbols()
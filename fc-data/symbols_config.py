# symbols_config.py
# Centralized configuration for Vietnamese stock symbols
# This ensures consistency across producer, consumer, and API

# Major Vietnamese Stock Indexes
VIETNAMESE_INDEXES = [
    ('VNIndex', 'HOSE'),      # Ho Chi Minh Stock Exchange Index
    ('VN30', 'HOSE'),         # VN30 Index (Top 30 companies)
    ('VNMidCap', 'HOSE'),     # VN MidCap Index
    ('VNSmallCap', 'HOSE'),   # VN SmallCap Index
    ('VNAllShare', 'HOSE'),   # VN AllShare Index
    ('HNXIndex', 'HNX'),      # Hanoi Stock Exchange Index
    ('HNX30', 'HNX'),         # HNX30 Index
    ('HNXCon', 'HNX'),        # HNX Construction Index
    ('HNXFin', 'HNX'),        # HNX Finance Index
    ('HNXLCap', 'HNX'),       # HNX Large Cap Index
    ('HNXMSci', 'HNX'),       # HNX Manufacturing & Science Index
    ('UpcomIndex', 'UPCOM'),  # UPCoM Index
]

# Top 50 Vietnamese Stocks (Major companies across sectors)
VIETNAMESE_STOCKS = [
    # Banking & Finance (VN30 Banks)
    ('VCB', 'Vietcombank', 'HOSE'),
    ('BID', 'BIDV', 'HOSE'),
    ('CTG', 'VietinBank', 'HOSE'),
    ('TCB', 'Techcombank', 'HOSE'),
    ('ACB', 'Asia Commercial Bank', 'HOSE'),
    ('MBB', 'Military Bank', 'HOSE'),
    ('STB', 'Sacombank', 'HOSE'),
    ('VPB', 'VPBank', 'HOSE'),
    ('TPB', 'Tien Phong Bank', 'HOSE'),
    ('EIB', 'Eximbank', 'HOSE'),
    
    # Real Estate & Construction
    ('VIC', 'Vingroup', 'HOSE'),
    ('VHM', 'Vinhomes', 'HOSE'),
    ('VRE', 'Vincom Retail', 'HOSE'),
    ('BCM', 'Becamex IDC', 'HOSE'),
    ('KDH', 'Khang Dien House', 'HOSE'),
    ('NVL', 'Novaland', 'HOSE'),
    ('PDR', 'Phat Dat Real Estate', 'HOSE'),
    ('DXG', 'Dat Xanh Group', 'HOSE'),
    
    # Manufacturing & Heavy Industry
    ('HPG', 'Hoa Phat Group', 'HOSE'),
    ('HSG', 'Hoa Sen Group', 'HOSE'),
    ('NKG', 'Nam Kim Group', 'HOSE'),
    ('POM', 'Pomina Steel', 'HOSE'),
    ('TVN', 'Vietnam Tanker', 'HOSE'),
    
    # Consumer Goods & Food
    ('VNM', 'Vinamilk', 'HOSE'),
    ('MSN', 'Masan Group', 'HOSE'),
    ('SAB', 'Sabeco', 'HOSE'),
    ('BHN', 'Bien Hoa Sugar', 'HOSE'),
    ('KDC', 'Kinh Do Corporation', 'HOSE'),
    ('MCH', 'Masan Consumer Holdings', 'HOSE'),
    
    # Technology & Telecommunications
    ('FPT', 'FPT Corporation', 'HOSE'),
    ('CMG', 'CMC Corporation', 'HOSE'),
    ('ELC', 'Electronics Corporation', 'HOSE'),
    ('ITD', 'IT&T Development', 'HOSE'),
    
    # Energy & Utilities
    ('GAS', 'PetroVietnam Gas', 'HOSE'),
    ('PLX', 'Petrolimex', 'HOSE'),
    ('POW', 'PetroVietnam Power', 'HOSE'),
    ('REE', 'Refrigeration Electrical Engineering', 'HOSE'),
    ('NT2', 'Nam Theun 2 Power', 'HOSE'),
    
    # Healthcare & Pharmaceuticals
    ('DHG', 'Hau Giang Pharmaceutical', 'HOSE'),
    ('IMP', 'Imexpharm', 'HOSE'),
    ('PME', 'Petrovietnam Medical', 'HOSE'),
    
    # Transportation & Logistics
    ('VJC', 'VietJet Aviation', 'HOSE'),
    ('HVN', 'Vietnam Airlines', 'HOSE'),
    ('GMD', 'Gemadept Corporation', 'HOSE'),
    ('PVT', 'PetroVietnam Transportation', 'HOSE'),
    
    # Retail & Services
    ('MWG', 'Mobile World Group', 'HOSE'),
    ('FRT', 'FPT Retail', 'HOSE'),
    ('PNJ', 'Phu Nhuan Jewelry', 'HOSE'),
    ('SBT', 'Saigon Beer Alcohol Beverage', 'HOSE'),
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
                'market': stock[2]
            }
    
    # Check indexes
    for index in VIETNAMESE_INDEXES:
        if index[0] == symbol:
            return {
                'type': 'index',
                'symbol': index[0],
                'market': index[1]
            }
    
    return None

# For backward compatibility
def get_symbols():
    """Legacy function name - returns stocks and indexes"""
    return get_all_symbols()

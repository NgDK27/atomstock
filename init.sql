CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    email VARCHAR(50) NOT NULL UNIQUE,
    balance NUMERIC(20, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE markets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT INTO markets (name) VALUES ('HOSE'), ('HNX'), ('UPCOM');

CREATE TABLE stocks (
    market_id INT REFERENCES markets(id),
    symbol VARCHAR(10) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    en_name VARCHAR(255)
);

CREATE TABLE indexes (
    market_id INT REFERENCES markets(id),
    symbol VARCHAR(20) PRIMARY KEY
);

INSERT INTO indexes (market_id, symbol) VALUES
    (1, 'VNIndex'),
    (1, 'VN30'),
    (2, 'HNXIndex'),
    (2, 'HNX30'),
    (3, 'HNXUpcomIndex');

CREATE TABLE daily_stocks (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol),
    trading_date DATE NOT NULL,
    price_change NUMERIC(10, 2), -- can be negative
    per_price_change NUMERIC(10, 2), -- can be negative
    ceiling_price NUMERIC(10, 2),
    floor_price NUMERIC(10, 2),
    ref_price NUMERIC(10, 2),
    open_price NUMERIC(10, 2),
    highest_price NUMERIC(10, 2),
    lowest_price NUMERIC(10, 2),
    close_price NUMERIC(10, 2),
    average_price NUMERIC(10, 2),
    close_price_adjusted NUMERIC(10, 2),
    total_match_vol BIGINT,
    total_match_val NUMERIC(20, 2),
    total_traded_vol BIGINT,
    total_traded_value NUMERIC(20, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (symbol, trading_date)
);

CREATE TABLE daily_indexes (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL REFERENCES indexes(symbol),
    index_value NUMERIC(10, 2),
    trading_date DATE NOT NULL,
    change NUMERIC(10, 2), -- can be negative
    ratio_change NUMERIC(10, 2), -- can be negative
    total_match_vol BIGINT,
    total_match_val NUMERIC(20, 2),
    total_deal_vol BIGINT,
    total_deal_val NUMERIC(20, 2),
    total_vol BIGINT,
    total_val NUMERIC(20, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (symbol, trading_date)
);

CREATE TABLE intraday_ohlc (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL, -- Index ID or Stock Symbol
    trading_date DATE NOT NULL,
    time TIMESTAMP NOT NULL,
    open NUMERIC(10, 2),
    high NUMERIC(10, 2),
    low NUMERIC(10, 2),
    close NUMERIC(10, 2),
    volume BIGINT,
    value NUMERIC(20, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (symbol, trading_date, time)
);

CREATE TABLE portfolios (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL REFERENCES users(id) 
);

CREATE TABLE portfolio_stocks (
    id SERIAL PRIMARY KEY,
    portfolio_id INT REFERENCES portfolios(id),
    symbol VARCHAR(10) NOT NULL,  -- Index ID or Stock Symbol
    quantity INT NOT NULL,
    purchase_price NUMERIC(10, 2) NOT NULL,
    purchase_date DATE NOT NULL
);

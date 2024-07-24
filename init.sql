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


CREATE TABLE rules (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL REFERENCES users(id),
    symbol VARCHAR(10) NOT NULL,
    rule_type VARCHAR(10) NOT NULL CHECK (rule_type IN ('BUY', 'SELL')),
    shares INTEGER NOT NULL,
    condition_type VARCHAR(20) NOT NULL CHECK (condition_type IN ('PRICE', 'VOLUME')),
    trigger_type VARCHAR(20) NOT NULL CHECK (trigger_type IN ('DAILY', 'WEEKLY', 'THRESHOLD')),
    trigger_value NUMERIC(10, 2),
    trigger_time TIME,
    trigger_day VARCHAR(10),
    range_type VARCHAR(10) CHECK (range_type IN ('ABOVE', 'BELOW')),
    stop_loss_percentage NUMERIC(5, 2) NOT NULL,
    spending_limit NUMERIC(10, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
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
    user_id VARCHAR(50) NOT NULL REFERENCES users(id),
    total_value NUMERIC(20, 2) NOT NULL DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trading_rules (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL REFERENCES users(id),
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol),
    shares INTEGER NOT NULL,
    entry_condition_type VARCHAR(20) NOT NULL CHECK (entry_condition_type IN ('PRICE', 'VOLUME')),
    entry_trigger_value NUMERIC(10, 2) NOT NULL,
    entry_range_type VARCHAR(10) NOT NULL CHECK (entry_range_type IN ('ABOVE', 'BELOW')),
    stop_loss_percentage NUMERIC(5, 2) NOT NULL,
    take_profit_percentage NUMERIC(5, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trades (
    id SERIAL PRIMARY KEY,
    rule_id INTEGER NOT NULL REFERENCES trading_rules(id),
    user_id VARCHAR(50) NOT NULL REFERENCES users(id),
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol),
    entry_price NUMERIC(10, 2) NOT NULL,
    entry_time TIMESTAMP NOT NULL,
    shares INTEGER NOT NULL,
    exit_price NUMERIC(10, 2),
    exit_time TIMESTAMP,
    exit_type VARCHAR(20) CHECK (exit_type IN ('STOP_LOSS', 'TAKE_PROFIT', 'MANUAL')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('OPEN', 'CLOSED'))
);
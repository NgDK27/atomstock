from ssi_fc_data import fc_md_client , model
import config
import psycopg2
import os
import time
from dotenv import load_dotenv, dotenv_values
from pathlib import Path

def get_project_root() -> Path:
    return Path(__file__).parent.parent.parent

project_root = get_project_root()

# Construct the path to the .env file
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv('.env')

DB_HOST = os.getenv('HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('USER')
DB_PASSWORD = os.getenv('PASSWORD')

client = fc_md_client.MarketDataClient(config)

def get_securities_list(market: str):
    req = model.securities(market, 1, 1000)
    res = client.securities(config, req)
    secs = res['data']
    total = res['totalRecord']
    valid = 0

    print(DB_HOST, DB_NAME, DB_USER, DB_PASSWORD)
    
    # Connect to the database
    conn = psycopg2.connect(
        host='localhost',
        dbname='capstone',
        user='quando',
        password=DB_PASSWORD
    )
    
    cursor = conn.cursor()

    cursor.execute("SELECT id FROM markets WHERE name = %s", (market,))
    market_id = cursor.fetchone()[0]

    for sec in secs:
        
        symbol = sec['Symbol']
        en_name = sec['StockEnName']

        if len(symbol) > 3:
            continue

        time.sleep(1)

        response = client.daily_stock_price(
            config,
            model.daily_stock_price(
                symbol,
                fromDate='09/08/2024',
                toDate='09/08/2024',
                pageIndex=1,
                pageSize=10
            )
        )

        print(response)
        
        if response['status'] != 'Success':
            continue

        print(f"Inserting {symbol} into the stocks table")

        # Insert data into the stocks table
        cursor.execute(
            """
            INSERT INTO stocks (market_id, symbol, en_name)
            VALUES (%s, %s, %s)
            """,
            (market_id, symbol, en_name)
        )

        valid += 1
    
    # Commit the transaction and close the connection
    conn.commit()
    cursor.close()
    conn.close()

    print(f"Inserted {valid} records into the stocks table out of {total} records")

get_securities_list('HOSE')
get_securities_list('HNX')
get_securities_list('UPCOM')


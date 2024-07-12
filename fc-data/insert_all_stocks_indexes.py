from ssi_fc_data import fc_md_client , model
import config
import psycopg2
import os
from dotenv import load_dotenv
from pathlib import Path

def get_project_root() -> Path:
    return Path(__file__).parent.parent.parent

project_root = get_project_root()

# Construct the path to the .env file
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

DB_HOST = os.getenv('HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('USER')
DB_PASSWORD = os.getenv('PASSWORD')

client = fc_md_client.MarketDataClient(config)

def get_securities_list():
    req = model.securities('UPCOM', 1, 1000)
    res = client.securities(config, req)
    secs = res['data']
    total = res['totalRecord']
    valid = 0
    
    # Connect to the database
    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    
    cursor = conn.cursor()
    
    # Fetch the market_id for 'HOSE'
    cursor.execute("SELECT id FROM markets WHERE name = 'UPCOM'")
    market_id = cursor.fetchone()[0]

    for sec in secs:
        symbol = sec['Symbol']
        name = sec['StockName']
        en_name = sec['StockEnName']

        if len(symbol) > 3:
            continue

        # Insert data into the stocks table
        cursor.execute(
            """
            INSERT INTO stocks (market_id, symbol, name, en_name)
            VALUES (%s, %s, %s, %s)
            """,
            (market_id, symbol, name, en_name)
        )

        valid += 1
    
    # Commit the transaction and close the connection
    conn.commit()
    cursor.close()
    conn.close()

    print(f"Inserted {valid} records into the stocks table")


from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime, timedelta
from ssi_fc_data import fc_md_client, model
import config
import os
from dotenv import load_dotenv
from pathlib import Path
import time
import psycopg2

app = FastAPI()

# Load environment variables
def get_project_root() -> Path:
    return Path(__file__).parent.parent.parent

project_root = get_project_root()
dotenv_path = project_root / 'oppenhomies/server/.env'
load_dotenv(dotenv_path)

DB_HOST = os.getenv('HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('USER')
DB_PASSWORD = os.getenv('PASSWORD')


def get_symbols():
    stock_symbols = []
    index_symbols = []

    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

    cursor = conn.cursor()

    try:
        # Query to fetch stock symbols
        cursor.execute("SELECT symbol FROM stocks")
        stock_symbols = [row[0] for row in cursor.fetchall()]

        # Query to fetch index symbols
        cursor.execute("SELECT symbol FROM indexes")
        index_symbols = [row[0] for row in cursor.fetchall()]

    except Exception as error:
        print("Error while fetching symbols:", error)

    return stock_symbols, index_symbols


stocks, indexes = get_symbols()

# Initialize the client
client = fc_md_client.MarketDataClient(config)

class StockPriceRequest(BaseModel):
    symbol: str
    range: str 

def get_date_range(range: str):
    end_date = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    if range == '1d':
        start_date = end_date
    elif range == '1w':
        start_date = end_date - timedelta(days=7)
    elif range == '1m':
        start_date = end_date - timedelta(days=30)
    elif range == '3m':
        start_date = end_date - timedelta(days=3*30)
    elif range == '6m':
        start_date = end_date - timedelta(days=6*30)
    elif range == '1y':
        start_date = end_date - timedelta(days=365)
    elif range == '5y':
        start_date = end_date - timedelta(days=5*365)
    else:
        raise ValueError("Invalid range. Use '1d', '1w', '1m', '3m', '6m', 1y', or '5y'.")
    return start_date, end_date

def fetch_stock_prices(symbol: str, start_date: datetime, end_date: datetime, range: str):
    all_data = []
    current_start = start_date
    
    if range in ['1d', '1w']:
        page_index = 1
        while True:
            response = client.intraday_ohlc(
                config, 
                model.intraday_ohlc(
                    symbol, 
                    start_date.strftime('%d/%m/%Y'), 
                    end_date.strftime('%d/%m/%Y'), 
                    pageIndex=page_index, 
                    pageSize=1000,
                    ascending=True,
                    resolution=1
                )
            )

            # time.sleep(1)
            if response['status'] != 'Success' and range == '1d':
                response = client.intraday_ohlc(
                    config, 
                    model.intraday_ohlc(
                        symbol, 
                        (start_date - timedelta(days=1)).strftime('%d/%m/%Y'), 
                        (end_date - timedelta(days=1)).strftime('%d/%m/%Y'), 
                        pageIndex=page_index, 
                        pageSize=1000,
                        ascending=True,
                        resolution=1
                    )
                ) 

            elif response['status'] != 'Success':
                break

            data = response['data']
            if not data:
                break

            filtered_data = [{'TradingDate': item['TradingDate'], 'Time': item['Time'], 'ClosePrice': item['Close']} for item in data]
            all_data.extend(filtered_data)
            
            if len(data) < 1000:
                break
            page_index += 1

    else:
        while current_start < end_date:
            current_end = min(current_start + timedelta(days=30), end_date)
            
            page_index = 1
            while True:
                # time.sleep(0)  
                if symbol not in ['VNIndex', 'VN30', 'HNXIndex', 'HNX30', 'HNXUpcomIndex']: #Stock
                    response = client.daily_stock_price(
                        config, 
                        model.daily_stock_price(
                            symbol, 
                            fromDate=current_start.strftime('%d/%m/%Y'), 
                            toDate=current_end.strftime('%d/%m/%Y'), 
                            pageIndex=page_index, 
                            pageSize=1000
                        )
                    )
                
                    if response['status'] != 'Success':
                        break

                    data = response['data']
                    if not data:
                        break

                    filtered_data = [{'TradingDate': item['TradingDate'], 'ClosePrice': item['ClosePrice']} for item in data]
                    all_data.extend(filtered_data)
                    
                    if len(data) < 1000:
                        break
                    page_index += 1
                
                else: #Index
                    response = client.daily_index(
                        config, 
                        model.daily_index(
                            '',
                            symbol, 
                            fromDate=current_start.strftime('%d/%m/%Y'), 
                            toDate=current_end.strftime('%d/%m/%Y'), 
                            pageIndex=page_index, 
                            pageSize=1000
                        )
                    )

                    if response['status'] != 'Success':
                        print(response)
                        break

                    data = response['data']
                    if not data:
                        break

                    filtered_data = [{'TradingDate': item['TradingDate'], 'IndexValue': item['IndexValue']} for item in data]
                    all_data.extend(filtered_data)
                    
                    if len(data) < 1000:
                        break
                    page_index += 1

            current_start = current_end + timedelta(days=1)

    return all_data

@app.get("/historical_prices/")
async def get_stock_prices(request: StockPriceRequest):
    try:
        start_date, end_date = get_date_range(request.range)
        data = fetch_stock_prices(request.symbol, start_date, end_date, request.range)
        return {"symbol": request.symbol, "data": data}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
    

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
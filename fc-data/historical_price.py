from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime, timedelta
from ssi_fc_data import fc_md_client, model
import config
import psycopg2
import os
from dotenv import load_dotenv
from pathlib import Path

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

# Initialize the client
client = fc_md_client.MarketDataClient(config)

class StockPriceRequest(BaseModel):
    symbol: str
    range: str  # '1m', '1y', '5y'

def get_date_range(range: str):
    end_date = datetime.now()
    if range == '1m':
        start_date = end_date - timedelta(days=30)
    elif range == '1y':
        start_date = end_date - timedelta(days=365)
    elif range == '5y':
        start_date = end_date - timedelta(days=5*365)
    else:
        raise ValueError("Invalid range. Use '1m', '1y', or '5y'.")
    return start_date.strftime('%d/%m/%Y'), end_date.strftime('%d/%m/%Y')

def fetch_stock_prices(symbol: str, from_date: str, to_date: str):
    page_index = 1
    all_data = []

    while True:
        response = client.daily_stock_price(
            config, 
            model.daily_stock_price(symbol, fromDate=from_date, toDate=to_date, pageIndex=page_index, pageSize=1000)
        )
        
        if response['status'] != 'Success':
            raise HTTPException(status_code=500, detail="Failed to fetch stock data")

        data = response['data']
        if not data:
            break

        filtered_data = [{'TradingDate': item['TradingDate'], 'ClosePrice': item['ClosePrice']} for item in data]
        all_data.extend(filtered_data)
        
        if len(data) < 1000:
            break
        page_index += 1

    return all_data


@app.get("/historical_prices/")
async def get_stock_prices(request: StockPriceRequest):
    try:
        from_date, to_date = get_date_range(request.range)
        data = fetch_stock_prices(request.symbol, from_date, to_date)
        return {"symbol": request.symbol, "data": data}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal Server Error")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)


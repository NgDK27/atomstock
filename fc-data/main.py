from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime, timedelta
from ssi_fc_data import fc_md_client, model
import config
import os
from dotenv import load_dotenv
from pathlib import Path
import time

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
    range: str  # '1d', '1w', 1m', '3m', '6m', '1y', '5y'

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

def fetch_stock_prices(symbol: str, start_date: datetime, end_date: datetime):
    all_data = []
    current_start = start_date
    
    while current_start < end_date:
        current_end = min(current_start + timedelta(days=30), end_date)
        
        page_index = 1
        while True:
            time.sleep(1)  # Wait for 1 second before making an API call
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
        data = fetch_stock_prices(request.symbol, start_date, end_date)
        return {"symbol": request.symbol, "data": data}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
# import ssi_fc_trading
from ssi_fc_data import fc_md_client , model
import config
import psycopg2

client = fc_md_client.MarketDataClient(config)
def md_access_token():
	print(client.access_token(model.accessToken(config.consumerID, config.consumerSecret)))

def md_get_securities_list():
    req = model.securities('UPCOM', 1, 1000)
    print(client.securities(config, req))

def md_get_index_components():
	print(client.index_components(config, model.index_components('HNXUpcomIndex', 1, 1000)))

def md_get_index_list():
	print(client.index_list(config, model.index_list()))

def md_get_intraday_OHLC():
	print(client.intraday_ohlc(config, model.intraday_ohlc('VNIndex', '11/07/2024', '11/07/2024', 1, 1000, True, 1)))

def md_get_daily_index():
	print(client.daily_index(config, model.daily_index('', 'VNIndex', '11/07/2024', '11/07/2024', 1, 100, '', '')))

def md_get_stock_price():
	print(client.daily_stock_price(config, model.daily_stock_price ('BT6', '11/07/2024', '11/07/2024', 1, 100)))

def main():
    
    while True:
        print('11  - Securities List')
        print('13  - Index Components')
        print('14  - Index List')
        print('16  - Intraday OHLC')
        print('17  - Daily index')
        print('18  - Stock price')
        value = input('Enter your choice: ')

        if value == '11':
            md_get_securities_list()
        elif value == '13':
            md_get_index_components()
        elif value == '14':
            md_get_index_list()
        elif value == '16':
            md_get_intraday_OHLC()
        elif value == '17':
            md_get_daily_index()
        elif value == '18':
            md_get_stock_price()

if __name__ == '__main__':
	main()
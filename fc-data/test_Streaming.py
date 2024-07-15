# import ssi_fc_data
import config
import json
from ssi_fc_data.fc_md_stream import MarketDataStream
from ssi_fc_data.fc_md_client import MarketDataClient



#get market data message
def get_market_data(message):
	print(message)


#get error
def getError(error):
	print(error)


#main function
def main():

	mm = MarketDataStream(config, MarketDataClient(config))
	mm.start(get_market_data, getError, '{chanel_name}:{symbol}')
	message = None
	while message != "exit()":
		message = input(">> ")
		if message is not None and message != "" and message != "exit()":
			mm.swith_channel(message)
	
main()
def bruh(channel):

	mm = MarketDataStream(config, MarketDataClient(config))
	mm.start(get_market_data, getError, channel)
	
# bruh("X:SSI")
# bruh('X:ACB')
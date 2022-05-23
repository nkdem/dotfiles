import ccxt
import random
import os 
import time

exchange = ccxt.whitebit()
exchange.load_markets()

class Market:
    last = 0
    percentage = 0
    def __init__(self, symbol,icon):
        self.symbol = symbol
        self.icon = icon
    def __str__(self):
        return f'Market: {self.symbol}\n Price: {self.last}\n Percentage: {self.percentage}%\n'

def update_markets():
    if (exchange.has['fetchTicker']):
        tickers = exchange.fetch_tickers(list(map(lambda x: x.symbol, markets)))
        for market in markets:
            market.last = tickers[market.symbol]['last']
            market.percentage = tickers[market.symbol]['percentage']

def update_sketchyBar(market):
    os.system(f'sketchybar -m --set crypto label="{market.icon} \${market.last} [{market.percentage}%]"')
    if market.percentage < 0:
        os.system('sketchybar -m --set crypto background.color=0xffE77D8F')
    else:
        os.system('sketchybar -m --set crypto background.color=0xffA8CC76')

btc = Market('BTC/USDT', '')
eth = Market('ETH/USDT', 'ETH') 
xmr = Market('XMR/USDT', 'XMR')
markets = [btc,eth,xmr] 

index = -1
while True:
    update_markets()
    index += 1
    update_sketchyBar(markets[index])
    if index == len(markets) - 1:
        index = -1
    time.sleep(exchange.rateLimit / 100)
    


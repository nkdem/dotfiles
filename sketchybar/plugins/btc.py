#!/usr/bin/env python3
import requests
import os

response = requests.get('https://api.gemini.com/v1/pricefeed')
jsonResponse = response.json()

for i in jsonResponse:
    if i["pair"] == "BTCGBP":
        percentChange = str(round((float(i["percentChange24h"]) * 100), 2))
        price = i["price"]
        os.system(f'sketchybar -m --set btc label=" £{price} [{percentChange}%]"')
        if "-" in percentChange:
            os.system('sketchybar -m --set btc background.color=0xffE77D8F')
        else:
            os.system('sketchybar -m --set btc background.color=0xffA8CC76')
        break

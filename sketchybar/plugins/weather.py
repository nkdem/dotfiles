from dotenv import load_dotenv
import os
import requests
import json  
import time

load_dotenv()
location = os.environ.get('LOCATION')

class Weather:
    def __init__(self, temp, wind):
        self.temp = temp 
        self.wind = wind

def get_weather():
    if location is None:
        return
    url = requests.get(f'https://wttr.in/{location}?format=j1')
    data = json.loads(json.dumps(json.loads(url.text)['current_condition'][0]))
    weather = Weather(data['temp_C'], data['windspeedKmph'])
    return weather 


def update_sketchyBar(weather):
    os.system(f'sketchybar -m --set weather label="{location} {weather.temp}°C"')

update_sketchyBar(get_weather())
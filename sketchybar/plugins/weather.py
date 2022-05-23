from dotenv import load_dotenv
import os
import requests
import json  
import time

load_dotenv()
location = os.environ.get('LOCATION')

class Weather:
    def __init__(self, temp, astronomy, desc, wind, direction):
        self.temp = temp
        self.astronomy = astronomy
        self.set_description(desc) 
        self.set_wind(wind,direction)
    def set_description(self, desc):
        if 'snow' in desc:
            self.desc = '❄️'
        elif 'rain' in desc:
            self.desc = '🌧'
        elif 'cloud' in desc:
            self.desc = '☁️'
        else:
            sunrise = [int(x) for x in astronomy[0]['sunrise'].replace(' AM', '').split(':')]
            sunset = [int(x) for x in astronomy[0]['sunset'].replace(' PM', '').split(':')]
            sunset[0] += 12
            current_hour = time.localtime().tm_hour
            if sunrise[0] >= current_hour or current_hour >= sunset[0]:
                self.desc = '🌑'
            else:
                self.desc = '☀️'
    def set_wind(self,wind,direction):
        self.wind = wind
        arrows = ["↓", "↙", "←", "↖", "↑", "↗", "→", "↘"]
        self.direction = arrows[round(((direction + 22)% 360) / 45)]
def get_weather():
    if location is None:
        return
    url = requests.get(f'https://wttr.in/{location}?format=j1')
    data = json.loads(url.text)
    weather = Weather(data['current_condition'][0]['temp_C'], data['weather'][0]['astronomy'],data['current_condition'][0]['weatherDesc'][0]['value'],int(data['current_condition'][0]['windspeedKmph']), int(data['current_condition'][0]['winddirDegree']))
    return weather 

weather = get_weather()
labels = [f'sketchybar -m --set weather label="{weather.desc} {location} {weather.temp}°C"', f'sketchybar -m --set weather label="{location}[{weather.direction} {weather.wind} km/h"]']

index = -1
while True:
    index += 1
    os.system(labels[index])
    if index == 1:
        print(weather.wind)
        index = -1 
    time.sleep(5)
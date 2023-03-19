#!/usr/bin/env bash

IP=$(curl -s https://ipinfo.io/ip)
LOCATION_JSON=$(curl -s https://ipinfo.io/"$IP"/json)

LOCATION="$(echo "$LOCATION_JSON" | jq '.city' | tr -d '"')"
REGION="$(echo "$LOCATION_JSON" | jq '.region' | tr -d '"')"
# COUNTRY="$(echo "$LOCATION_JSON" | jq '.country' | tr -d '"')"

# Line below replaces spaces with +
LOCATION_ESCAPED="${LOCATION// /+}+${REGION// /+}"
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=j1")

# Fallback if empty
if [ -z "$WEATHER_JSON" ]; then

  sketchybar --set "$NAME" label="No Data"
  sketchybar --set "$NAME".moon icon=
  
  return
fi

TEMPERATURE=$(echo "$WEATHER_JSON" | jq '.current_condition[0].temp_C' | tr -d '"')
WEATHER_DESCRIPTION=$(echo "$WEATHER_JSON" | jq '.current_condition[0].weatherDesc[0].value' | tr -d '"' | sed 's/\(.\{25\}\).*/\1.../')
WEATHER_CODE=$(echo "$WEATHER_JSON" | jq '.current_condition[0].weatherCode' | tr -d '"')

# This part was based on wttr.in source code.
# Sunny weather at midnight is kinda ok.
case $WEATHER_CODE in
    "113") LABEL="Sunny";;
    "116") LABEL="PartlyCloudy";;
    "119") LABEL="Cloudy";;
    "122") LABEL="VeryCloudy";;
    "143") LABEL="Fog";;
    "176") LABEL="LightShowers";;
    "179") LABEL="LightSleetShowers";;
    "182") LABEL="LightSleet";;
    "185") LABEL="LightSleet";;
    "200") LABEL="ThunderyShowers";;
    "227") LABEL="LightSnow";;
    "230") LABEL="HeavySnow";;
    "248") LABEL="Fog";;
    "260") LABEL="Fog";;
    "263") LABEL="LightShowers";;
    "266") LABEL="LightRain";;
    "281") LABEL="LightSleet";;
    "284") LABEL="LightSleet";;
    "293") LABEL="LightRain";;
    "296") LABEL="LightRain";;
    "299") LABEL="HeavyShowers";;
    "302") LABEL="HeavyRain";;
    "305") LABEL="HeavyShowers";;
    "308") LABEL="HeavyRain";;
    "311") LABEL="LightSleet";;
    "314") LABEL="LightSleet";;
    "317") LABEL="LightSleet";;
    "320") LABEL="LightSnow";;
    "323") LABEL="LightSnowShowers";;
    "326") LABEL="LightSnowShowers";;
    "329") LABEL="HeavySnow";;
    "332") LABEL="HeavySnow";;
    "335") LABEL="HeavySnowShowers";;
    "338") LABEL="HeavySnow";;
    "350") LABEL="LightSleet";;
    "353") LABEL="LightShowers";;
    "356") LABEL="HeavyShowers";;
    "359") LABEL="HeavyRain";;
    "362") LABEL="LightSleetShowers";;
    "365") LABEL="LightSleetShowers";;
    "368") LABEL="LightSnowShowers";;
    "371") LABEL="HeavySnowShowers";;
    "374") LABEL="LightSleetShowers";;
    "377") LABEL="LightSleet";;
    "386") LABEL="ThunderyShowers";;
    "389") LABEL="ThunderyHeavyRain";;
    "392") LABEL="ThunderySnowShowers";;
    "395") LABEL="HeavySnowShowers";;
esac

case $LABEL in
    "Unknown") ICON="";;
    "Cloudy") ICON="";;
    "Fog") ICON="";;
    "HeavyRain") ICON="";;
    "HeavyShowers") ICON="";;
    "HeavySnow") ICON="";;
    "HeavySnowShowers") ICON="";;
    "LightRain") ICON="";;
    "LightShowers") ICON="";;
    "LightSleet") ICON="";;
    "LightSleetShowers") ICON="";;
    "LightSnow") ICON="";;
    "LightSnowShowers") ICON="";;
    "PartlyCloudy") ICON="";;
    "Sunny") ICON="";;
    "ThunderyHeavyRain") ICON="";;
    "ThunderyShowers") ICON="";;
    "ThunderySnowShowers") ICON="";;
    "VeryCloudy") ICON="";;
esac

sketchybar --set "$NAME" label="$TEMPERATURE 糖 $WEATHER_DESCRIPTION"
sketchybar --set "$NAME".moon icon="$ICON"

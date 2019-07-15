
data=$(curl -s https://weather-broker-cdn.api.bbci.co.uk/en/forecast/aggregated/727011)

#http://ip-api.com/line/?fields=lat,lon

weather_today(){
    echo "Weather for today"
    while IFS= read -r line
    do
    line=$(echo $line | tr '"' ' ')
    date=$(echo "$line" | cut -d'|' -f1)
    temp=$(echo "$line" | cut -d'|' -f2)
    hook=$(echo "$line" | cut -d'|' -f3)
    echo -e "$date $temp $hook"
    done < <(echo $data | jq '.forecasts[0].detailed.reports[]|"\(.localDate)_\(.timeslot)| \(.temperatureC)C| \(.enhancedWeatherDescription)" ')
}
weather_forecast(){
    echo "Weather forecast"
    while IFS= read -r line
    do
    line=$(echo $line | tr '"' ' ')
    date=$(echo "$line" | cut -d'|' -f1)
    temp=$(echo "$line" | cut -d'|' -f2)
    hook=$(echo "$line" | cut -d'|' -f3)
    icons=$(echo $hook | sed 's/intervals//gi; s/and//g; s/\ a\ //g; s/Sunny/\xe2\x98\x80/gi; s/showers/\xe2\x98\x94/gi; s/thundery/\\U26c8/gi; s/gentle\ breeze/\\U1f32b/gi')
    echo -e "$date $temp $hook"
    done < <(echo $data | jq '.forecasts[]|"\(.summary.report.localDate)| \(.summary.report.minTempC)C/\(.summary.report.maxTempC)C| \(.summary.report.enhancedWeatherDescription)"')
}

paste -d'|' <(weather_today) <(weather_forecast) | column -t -s '|'

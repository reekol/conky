
data=$(curl -s https://weather-broker-cdn.api.bbci.co.uk/en/forecast/aggregated/727011)

#http://ip-api.com/line/?fields=lat,lon
#http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=EUR|BG|SOFIA
icon(){
    echo -n "\${image ~/.conky/weather_icons/${1}.png -s 18x18"
}

weather_today(){
    local i=5
    while IFS= read -r line
    do
        line=$(echo $line | tr '"' ' ')
        date=$(echo "$line" | cut -d'|' -f1)
        temp=$(echo "$line" | cut -d'|' -f2)
        hook=$(echo "$line" | cut -d'|' -f3)
        echo -e "\n         $date $temp $hook"
        ((i+=20))
    done < <(echo $data | jq '.forecasts[0].detailed.reports[]|"\(.localDate)_\(.timeslot)| \(.temperatureC)C| \(.enhancedWeatherDescription)" ')
}

weather_forecast(){
    local i=5
    while IFS= read -r line
    do
        line=$(echo $line | tr '"' ' ')
        date=$(echo "$line" | cut -d'|' -f1)
        temp=$(echo "$line" | cut -d'|' -f2)
        hook=$(echo "$line" | cut -d'|' -f3)
        if [ 1 -eq $(echo $hook | grep 'Partly cloudy'                       | wc -l) ]; then echo -n "$(icon Partly_Cloudy) -p  0,$i }"; fi
        if [ 1 -eq $(echo $hook | grep 'Partly cloudy and light winds'       | wc -l) ]; then echo -n "$(icon Windy        ) -p 20,$i }"; fi
        if [ 1 -eq $(echo $hook | grep 'Sunny intervals and a gentle breeze' | wc -l) ]; then echo -n "$(icon Sunny        ) -p  0,$i }"; fi
        if [ 1 -eq $(echo $hook | grep 'Sunny intervals and a gentle breeze' | wc -l) ]; then echo -n "$(icon Windy        ) -p 20,$i }"; fi
        if [ 1 -eq $(echo $hook | grep 'Sunny and a gentle breeze'           | wc -l) ]; then echo -n "$(icon Sunny        ) -p  0,$i }"; fi
        if [ 1 -eq $(echo $hook | grep 'Sunny and a gentle breeze'           | wc -l) ]; then echo -n "$(icon Windy        ) -p 20,$i }"; fi
        if [ 1 -eq $(echo $hook | grep 'A clear sky and light winds'         | wc -l) ]; then echo -n "$(icon Windy        ) -p 20,$i }"; fi
        echo -e "\n         $date $temp $hook"
        ((i+=20))
    done < <(echo $data | jq '.forecasts[]|"\(.summary.report.localDate)| ${color1}\(.summary.report.minTempC)C / \(.summary.report.maxTempC)C${color}| \(.summary.report.enhancedWeatherDescription)"')
}

#paste -d'|' <(weather_today) <(weather_forecast) | column -t -s '|'
#weather_today | column -t -s '|'
weather_forecast | column -t -s '|'


source $PWD/config.sh
#data=$(curl -s --cookie "weather=unit%3Dmetric" "https://www.yahoo.com/news/weather/$(getConfig c_weather_loc)" --compressed) && echo $data > $PWD/cache/wtr.cache
data=$(cat $PWD/cache/wtr.cache)
format=$1

getPos(){
    echo $(echo $1 | grep -b -o "$2" | cut -d':' -f1 | head -n $3 | tail -n1)
}

substr(){
    local fr=$(getPos "$1" "$2" "$3")
    local to=$(getPos "$1" "$4" "$5")
    echo $1 | cut -b $(($fr+1))-$to | sed 's/amp\;//g' | grep -v -e '^[[:space:]]*$'
}

count(){
    echo $1 | grep -o $2 | wc -l
}

urlCache(){
    url=$(substr $1 "http" 1 '"' 2)
    bnm=$(basename $url)
    cch="$PWD/cache/$bnm"
    [ -f  $cch ] || curl -s -o $cch $url
    echo $cch
}

getToday(){
    local table=$(substr "$data" 'id=module-weather-forecast' 1 'class="weather-stream-' 1)
    local today=$(substr "$table" '<ul' 1 '</ul' 1)
    local hours=$(count "$today" "<li")

    local hur=""
    local img=""
    local src=""
    (
        for i in $(seq 1 $hours); do
             timeoftheday=$(substr "$today"   '<li ' $i '</li>' $i)

             timeofthedayClock=$(substr "$timeoftheday"   '<time>' 1 '</time>' 1)
             tempC=$(substr "$timeoftheday" "<dd " 2 "</dd>" 2)
             alt=$(substr "$timeoftheday" 'alt=' 1 '><dl' 1 | sed 's/ /_/g' | cut -c 5-)
             srcTemp=$(substr "$timeoftheday" ' data-wf-src=' 1 ' src=' 1 | cut -c 14- )

             precipaion=$(substr "$timeoftheday" 'class="item precipitation"' 1 'class="item wind"' 1 )
             precipaionPercent=$(substr "$precipaion" "<dt" 2 "</dt" 2)
             srcPrecip=$(substr "$precipaion" ' data-wf-src=' 1 ' src=' 1 | cut -c 14- )

             wind=$(substr "$timeoftheday" 'class="item wind"' 1 '</li>' 1 )
             windSpeed=$(substr "$wind" "<dd" 2 "</dd" 2)

             srcTemp=$(urlCache $srcTemp)
             srcPrecip=$(urlCache $srcPrecip)
            echo "$timeofthedayClock $tempC $precipaionPercent $windSpeed $alt $srcTemp $srcPrecip"

         done

        ) |  sed 's/<[^>]*>//gi' | column -t  | awk '{ print "${goto 50}${voffset 5}${font Monospace:size=7}"$1$2" "$3" Pcp:"$4" Ws:"$5"km/h ${image "$7" -s 20x20 -p 0,"( 10 + (NR-1) * 18)" -f 86400} ${image "$8" -s 20x20 -p 30,"( 10 + (NR-1) * 18)" -f 86400} "     }'
}

#echo $data

if [ "$format" = "short" ]; then
    getToday
else
    getToday
fi

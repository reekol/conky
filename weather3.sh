
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
    local posTop=100
    (
        for i in $(seq 1 $hours); do
             timeoftheday=$(substr "$today"   '<li ' $i '</li>' $i)

             timeofthedayClock=$(substr "$timeoftheday"   '<time>' 1 '</time>' 1 | sed 's/<[^>]*>//gi')
             tempC=$(substr "$timeoftheday" "<dd " 2 "</dd>" 2 | sed 's/<[^>]*>//gi')
             alt=$(substr "$timeoftheday" 'alt=' 1 '><dl' 1 | sed 's/\"//g' | cut -c 5- | sed 's/<[^>]*>//gi')
             srcTemp=$(substr "$timeoftheday" ' data-wf-src=' 1 ' src=' 1 | cut -c 14- )

             precipaion=$(substr "$timeoftheday" 'class="item precipitation"' 1 'class="item wind"' 1 )
             precipaionPercent=$(substr "$precipaion" "<dt" 2 "</dt" 2 | sed 's/<[^>]*>//gi')
             srcPrecip=$(substr "$precipaion" ' data-wf-src=' 1 ' src=' 1 | cut -c 14- )

             wind=$(substr "$timeoftheday" 'class="item wind"' 1 '</li>' 1 )
             windSpeed=$(substr "$wind" "<dd" 2 "</dd" 2 | sed 's/<[^>]*>//gi')

             srcTemp=$(urlCache $srcTemp)
             srcPrecip=$(urlCache $srcPrecip)

            echo "-gravity northwest -pointsize 40 -font helvetica -fill white -annotate +120+$((posTop+10)) '$timeofthedayClock' \\"
            echo "-gravity northwest -pointsize 70 -font helvetica -fill white -annotate +120+$((posTop+60)) '$tempC' \\"

            echo " \"$srcTemp\"    -gravity northwest  -geometry  +240+$posTop -composite \\"
            echo " \"$srcPrecip\"  -gravity northwest  -geometry  +380+$((posTop+15)) -composite \\"

            echo "-gravity northwest -pointsize 40 -font helvetica -fill white -annotate +460+$((posTop+10)) '$precipaionPercent' \\"
            echo "-gravity northwest -pointsize 40 -font helvetica -fill white -annotate +400+$((posTop+60)) '~~ $windSpeed km/h' \\"
            echo "-gravity northwest -pointsize 70 -font helvetica -fill white -annotate +700+$((posTop+10)) '$alt' \\"
            posTop=$((posTop+160))
         done



        ) #|  sed 's/<[^>]*>//gi'
}

getDays(){
    local table=$(substr "$data" 'tenDayForecast' 1 '</table>' 1)
    local days=$(count "$table" 'role=row')
    local posTop=100
    (
        for i in $(seq 1 $days); do
            local dayi=$(substr "$table"   'role=row' $i 'day-part-1 showDayPart' $i)
            local dayName=$(substr "$dayi" '</button>' 1 '</td' 1 | sed 's/<[^>]*>//gi')
            local srcTemp=$(substr "$dayi" ' data-wf-src=' 1 ' src=' 1 | cut -c 14- )
            local srcPrecip=$(substr "$dayi" ' data-wf-src=' 2 ' src=' 2 | cut -c 14- )
            local tempCHigh=$(substr "$dayi" "<dd " 3 "</dd>" 3 | sed 's/<[^>]*>//gi')
            local tempCLow=$(substr "$dayi" "<dd " 5 "</dd>" 5 | sed 's/<[^>]*>//gi')
            local precipaionPercent=$(substr "$dayi" "<dd class=\"Mstart" 1 "</td>" 3 | sed 's/<[^>]*>//gi' )

            local srcTemp=$(urlCache $srcTemp)
            local srcPrecip=$(urlCache $srcPrecip)

            echo "-gravity northwest -pointsize 80 -font helvetica -fill white -annotate +2400+$((posTop+0)) '$dayName' \\"
            echo "-gravity northwest -pointsize 60 -font helvetica -fill red   -annotate +2200+$((posTop+0)) '$tempCHigh' \\"
            echo "-gravity northwest -pointsize 60 -font helvetica -fill white  -annotate +2200+$((posTop+80)) '$tempCLow' \\"
            echo "-gravity northwest -pointsize 40 -font helvetica -fill white -annotate +2310+$((posTop+70)) '$precipaionPercent' \\"
            echo " \"$srcPrecip\"    -gravity northwest  -geometry  +2300+$posTop -composite \\"
            echo " \"$srcTemp\"      -gravity northwest  -geometry  +2050+$((posTop-5)) -composite \\"

            posTop=$((posTop+200))

        done
        )
}



#echo "convert -size 6000x4000 xc:transparent cache/bg.jpg && "
echo "convert cache/bg.jpg \\"

if [ "$format" = "today" ]; then
    getToday

elif [ "$format" = "days" ]; then
    getDays
else
    getToday
    getDays
fi

#echo " -resize 1080x1920 \\"
echo " cache/output.jpg"

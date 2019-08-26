
source $PWD/config.sh
data=$(curl -s "https://www.yahoo.com/news/weather/$(getConfig c_weather_loc)" -H 'authority: www.yahoo.com' -H 'cache-control: max-age=0' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36' -H 'sec-fetch-mode: navigate' -H 'sec-fetch-user: ?1' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'sec-fetch-site: none' -H 'referer: https://www.google.com/' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.9,bg-BG;q=0.8,bg;q=0.7,ru;q=0.6' -H 'cookie: weather=unit%3Dmetric; thamba=2; APID=UP7a1b1400-d568-11e8-9d1f-02c3d9916472; GUCS=ASYt3dSG; GUC=AQABAQFdRc5eMEIengRd&s=AQAAADHu-Pu-&g=XUSKGA; APIDTS=1564772988; B=6ipq01pdt4a8f&b=3&s=0d' --compressed) && echo $data > $PWD/cache/wtr.cache
data=$(cat $PWD/cache/wtr.cache)

getPos(){
    echo $(echo $1 | grep -b -o "$2" | cut -d':' -f1 | head -n $3 | tail -n1)
}

substr(){
    local fr=$(getPos "$1" "$2" "$3")
    local to=$(getPos "$1" "$4" "$5")
    echo $1 | cut -b $(($fr+1))-$to | sed 's/amp\;//g' | grep -v -e '^[[:space:]]*$'
}

urlCache(){
    url=$(substr $1 "http" 1 '"' 2)
    bnm=$(basename $url)
    cch="$PWD/cache/$bnm"
    [ -f  $cch ] || curl -s -o $cch $url
    echo $cch
}

getToday(){
    local table=$(substr "$data" 'class="forecast"' 1 'id="weather-precipitation"' 1)
    local today=$(substr "$table" 'data-reactid="9"' 1 'data-reactid="193"' 1)
    local hur=""
    local img=""
    local src=""
    (
        for i in $(seq 1 24); do
            hur=$(substr "$today" "<li" $i '</li>' $i)
            img=$(substr "$hur"   "<img alt" 1 ' data-reactid="' 4)
            alt=$(substr "$img"   "alt=" 1 " height" 1 | tr ' ' '_')
            src=$(substr "$img"   "src=" 1 " data-re" 1)
            src=$(urlCache $src)
            echo "$i) $hur $alt $src"
        done


    ) | sed 's/<!--[^>]*-->/ /g' | sed 's/<[^>]*>//gi' | grep -v -e '^[[:space:]]*$' | tr '="' ' ' | awk '{
        print "${goto 40}${voffset 6}${font Monospace:size=7}"$2$3" "$4$5" "$7" ${image "$8" -s 20x20 -p 0,"((NR-1) * 18)" -f 86400} "
    }' | column -t
}

getForecast(){
    local table=$(substr "$data" 'class="forecast"' 1 'id="weather-precipitation"' 1)
    (
    for i in $(seq 1 10); do
        local row=$(substr "$table" 'role="row"' $i '</div>"' $((i+2)) )
        local day=$(echo "<weather2 $row>" |  sed 's/<!--[^>]*-->/ /g' |  sed 's/<[^>]*>//gi' | cut -d' ' -f1)
        local imgCond=$(substr "$row" 'src="' 1 'data-reactid=' 5 | cut -d'"' -f2 ) && imgCond=$(urlCache $imgCond)
        local imgDrop=$(substr "$row" 'src="' 2 'data-reactid=' 8 | cut -d'"' -f2 ) && imgDrop=$(urlCache $imgDrop)
        local dropText=$(substr "$row" '<img ' 2 '</span>' 4 | sed 's/<[^>]*>//gi'  )
        local descr=$(echo "<i $(substr "$row" 'class="day-part' 1 '</div>' 2)" | sed 's/<!--[^>]*-->/ /g' | sed 's/<[^>]*>//gi')
        local temps=$(echo "< $(substr "$row" 'class="D(ib) Va(m) W(1/4) Ta(end)"' 1 'class="day-part' 1)>" | sed 's/<!--[^>]*-->//g' | sed 's/<[^>]*>/ /gi' )
        echo '${goto 50}${voffset 6}${font Monospace:size=7}'$dropText'|'$day'|'$temps'|'$descr'${image '$imgCond' -s 20x20 -p 0,' $(( 435 + (i-1) * 18 ))' -f 86400} ${image '$imgDrop' -s 14x14 -p 25,'$(( 435 + (i-1) * 18 ))' -f 86400}'
#        echo  -e "\n$day - $temps\n$imgCond\n$imgDrop $dropText\n$descr"
    done
    ) | column -t -s '|'

}

getNow(){
    local cwtr="<weather2 $(substr "$data" 'data-type="temperature"' 1 'by chojaein on' 1 )"
    local imgCond=$(substr "$cwtr" 'src="' 1 '" data-reactid=' 5 | cut -d'"' -f2) && imgCond=$(urlCache $imgCond)
    local descr=$(substr "$cwtr" '<span class="description' 1 '</span></div><div class="high-low' 1 | sed 's/<[^>]*>//gi')
    local trange=$(substr "$cwtr" '<div class="high-low ' 1 '<div class="now' 1 | sed 's/<[^>]*>//gi')
    local now=$(substr "$cwtr" '<div class="now' 1 '<div class="credit' 1 | sed 's/<[^>]*>//gi' | tr 'F' ' ')
    echo "\${voffset -160}"
#    echo "\${goto 960}\${font Monospace:size=15}$now\${font}"
    echo "\${goto 995}$descr $trange"
    echo "\${goto 995}\${font Monospace:size=15}$now\${font}"
    echo '${image '$imgCond' -s 50x50 -p 990,500 -f 86400}'
}
getToday
getForecast
getNow

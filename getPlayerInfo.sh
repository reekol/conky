#!/bin/sh

cmd='/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata'
imgUrl="https://img.youtube.com/vi/HOOK/0.jpg"

getPos(){
    echo $(echo $1 | grep -b -o "$2" | cut -d':' -f1 | head -n $3 | tail -n1)
}

substr(){
    local fr=$(getPos "$1" "$2" "$3")
    local to=$(getPos "$1" "$4" "$5")
    echo $1 | cut -b $(($fr+1))-$to | sed 's/amp\;//g' | grep -v -e '^[[:space:]]*$'
}

urlCache(){
    url=$1
    bnm=$(echo $url | md5sum - | tr '-' ' ')
    cch="$PWD/cache/$bnm"
    [ -f  $cch ] || curl -s -o $cch $url
    echo -e $cch
}

nfo=$(
    if [[ `qdbus | egrep -i 'org.mpris.MediaPlayer2|plasma-browser-integration' | wc -l` -eq 1 ]]; then
        qdbus `qdbus | egrep -i 'org.mpris.MediaPlayer2|plasma-browser-integration'` $cmd
    else
        qdbus `cat $PWD/cache/currentPlaying.txt` $cmd
    fi
)

token=$(echo "$nfo" | grep ':url'   | awk '{print $2}' | cut -d'=' -f2)
title=$(echo "$nfo" | grep ':title' | cut -d':' -f3)
cached=$(urlCache "$(echo $imgUrl | sed s/HOOK/$token/g)")
unset cmd

echo '${color0}${goto 120}${voffset 20}'$title$'${color}'
echo '${image '$cached'  -s 100x80 -p 0,160}'

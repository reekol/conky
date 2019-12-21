#!/bin/bash
source $PWD/config.sh

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

rm $comicCache
rm $imgCache
comicCache=$(urlCache "https://garfield.com/comic")
comic=$(cat $comicCache)
element=$(substr "$comic" 'class="comic-arrow-left"' 1 '" width="1200"' 1 )
img=$(substr "$element" 'https://' 1 'width="1200"' 1 )
imgCache=$(urlCache "$img")
echo "\${image $imgCache -s 600x200 -p 10,10 -f 86400}"


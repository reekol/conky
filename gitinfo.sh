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

name=$(getConfig c_github_user)
repoCache=$(urlCache "https://github.com/$name")
repo=$(cat $repoCache)
uid=$(substr "$repo" 'data-scope-id="' 1 '" data-scoped-search-url' 1 | sed 's/data-scope-id="//g')
avatar=$(urlCache "https://avatars0.githubusercontent.com/u/$uid")
svg=$(substr "$repo" '<svg width=' 1 '</g></svg>' 1)
rm  $repoCache
echo "\${image $avatar -s 145x145 -p 5,5 -f 86400}" 
echo "$svg</g></svg>" > $PWD/cache/gitcontrib.svg
convert -fuzz 15% -transparent white  $PWD/cache/gitcontrib.svg $PWD/cache/gitcontrib.png
echo "\${image $PWD/cache/gitcontrib.png -s 800x120 -p 160,30 -f 86400}" 
echo "\${voffset -30}\${goto 170}\${font Monospace:size=18}$name"

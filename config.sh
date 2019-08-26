#!/bin/bash

getConfig () { 
    local str=$(cat $PWD/.config | awk '{print $1" "$2}' | grep $1 | cut -d' ' -f2 )
    [ $2 ] && str=$(echo $str | sed -e "s/$2/$3/g")
    echo $str
}

#!/bin/bash

trap 'kill 0' EXIT
window=$1
callback=$2
coproc (trap '' PIPE; xev -id $(xdotool search --name $window |\
        tr "\n" ",")0 -event mouse                       |\
        grep --line-buffered -e "^Button" -A 2           |\
        grep --line-buffered 'state 0x100' -B 1          |\
        grep --line-buffered -v 'state\|--' & disown)
while read -r line
do
    params=$(echo $line | tr '()', ' ' | awk '{print $6 " " $7 " " $8 " " $10 " " $11}')
	echo "[[[ $window $params ]]]";
	bash -c "$callback $window $params"
done <&${COPROC[0]}


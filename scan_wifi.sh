
iwlist scan 2>&1 | grep 'ESSID\|Address' | awk '{printf " %s%s",$0,(NR%2?FS:RS)}' | sed -e 's/ESSID:\|Address\|Cell\ [0-9][0-9]\ -\ //g' | sed 's/  */ /g' | sed 's/^\ \:/ /g' | tr '"' ' '

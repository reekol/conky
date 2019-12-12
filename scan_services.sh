netstat -auntp | grep 'LISTEN' | awk '{print $4 " " $7}' | sed -E "s~(.*):([0-9]+)~\\2~" | sed -E "s~(\\s.*)/(.*)~ \\2~" | sort -k 1,1 | uniq -c | awk -F ' ' '{print $3 " " $2 " " $1 }' | column -t

#/bin/bash

ips=`for ip in $(cat ~/.ssh/config | grep Name | cut -d' ' -f6); do (ping -c 1 -w 1 $ip &>/dev/null; echo "$?-$ip" ) & done`;wait

print_res(){
    for ip in $ips; do 
        local s=`echo $ip | cut -d'-' -f1`
        local i=`echo $ip | cut -d'-' -f2`
        echo "\n\${color$s}" $i $(cat ~/.ssh/config | grep "$i$" -B2 | grep Host\ | cut -d' ' -f2)
    done
}

res=$(print_res | sort -r | column -t)
echo -e $res | grep -v -E '^\$\{color0\}(.*)(sofia)' | column -t

offline=$(echo -e $res | grep -v -E '^\$\{color0\}' | grep color1 | wc -l)
#if [ $offline -gt '0' ]; then play /usr/share/sounds/KDE-Im-Connection-Lost.ogg ; fi



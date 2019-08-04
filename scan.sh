#/bin/bash

[ -f ~/.ssh/config ] && ips=`for ip in $(cat ~/.ssh/config | grep Name | cut -d' ' -f6); do (ping -c 1 -w 1 $ip &>/dev/null; echo "$?-$ip" ) & done`;wait

print_res(){
    for ip in $ips; do 
        local s=`echo $ip | cut -d'-' -f1`
        local i=`echo $ip | cut -d'-' -f2`
        echo "\n\${color$s}" $i $(cat ~/.ssh/config | grep "$i$" -B2 | grep Host\ | cut -d' ' -f2)
    done
}

res=$(print_res | sort -r | column -t)
#echo -e $res | grep -v -E '^\$\{color0\}(.*)(sofia)' | column -t
echo -e $res | column -t
#offline=$(echo -e $res | grep -v -E '^\$\{color0\}' | grep color1 | wc -l)
#[ $offline -gt '0' ] && play /usr/share/sounds/Oxygen-K3B-Finish-Success.ogg



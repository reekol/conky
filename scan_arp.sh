
(for ip in $(for ip in $(arp -a|cut -d' ' -f2|tr '()' ' ');do (ping -c1 -w2 $ip 2>&1 >/dev/null;echo '${color'$(($?+1))"}-$ip")&done;wait);do echo ''$(arp -a |grep "($(echo $ip|cut -d'-' -f2))"| cut -d' ' -f4)" $ip"'${color}';done) | sed 's/{color1}-/{color0}/g'  |column -t

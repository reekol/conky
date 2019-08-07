#/bin/bash

# Example ./.ssh/config contents
#
# Host niki-remote-app-1
#     HostName 192.168.100.1
#     ForwardAgent yes
#     User root
#     Port 22
#     IdentityFile ~/.ssh/my_secret_key
# 
# Host niki-remote-app-2
#     HostName 192.168.100.2
#     ForwardAgent yes
#     User root
#     Port 22
#     IdentityFile ~/.ssh/my_secret_key


lastOffline=$(cat $PWD/cache/scan.offline.log)
lastHash=$lastOffline #$(echo "$lastOffline" | md5sum -)

[ -f ~/.ssh/config ] && ips=`for ip in $(cat ~/.ssh/config | grep Name | awk '{print $2}'); do (ping -c 1 -w 2 $ip &>/dev/null; echo "$?-$ip" ) & done`;wait

print_res(){
    for ip in $ips; do 
        local s=`echo $ip | cut -d'-' -f1`
        local i=`echo $ip | cut -d'-' -f2`
        echo "\n\${color$s}" $i $(cat ~/.ssh/config | grep "$i$" -B2 | grep Host\ | cut -d' ' -f2)
    done
}

res=$(print_res | sort -r | column -t)

echo -e $res | column -t
offline="$(echo  "$res" | grep -v -E '^\$\{color0\}' | grep color1 | awk '{print $3}')"
offlineHash=$offline #$(echo "$offline" | md5sum - )
if [ "$lastHash" != "$offlineHash" ]; then
    echo "$offline" > $PWD/cache/scan.offline.log
    n=$(echo "$offline" | wc -l);
    if [ $n -eq "0" ]; then
        (echo "All servers online" |  espeak -p 99 -s 150) &
    else
        if [ $n -lt "3" ]; then
            if [ $n -eq "1" ]; then
                (echo "$offline, is offline" |  espeak -a 30 -p 99 -s 150) &
            else
                (echo "$n servers, $offline, are offline" |  espeak -a 30 -p 99 -s 150) &
            fi
        else
            (echo "$n servers offline" |  espeak -p 99 -s 150) &
        fi
    fi
fi




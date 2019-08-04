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


[ -f ~/.ssh/config ] && ips=`for ip in $(cat ~/.ssh/config | grep Name | awk '{print $2}'); do (ping -c 1 -w 1 $ip &>/dev/null; echo "$?-$ip" ) & done`;wait

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



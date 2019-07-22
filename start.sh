
sudo killall conky

#sed -i "s/enp[0-9]s0/$(ip link | awk -F: '$0 !~ "lo|vir|wl|dock|^[^0-9]"{print $2;getline}')/gi" ./.conkyrc
#sed -i "s/wlp[0-9]s0/$(iw dev | grep face | cut -d' ' -f2)/gi" ./.conkyrc

sed -i "s/wlp[0-9]s0/$(ls /sys/class/net | grep wlp)/gi" ./.conkyrc
sed -i "s/enp[0-9]s0/$(ls /sys/class/net | grep enp)/gi" ./.conkyrc

#GET /wifi HTTP/1.1
#socat -vv TCP-LISTEN:1234,crlf,reuseaddr,fork SYSTEM:"echo HTTP/1.0 200; echo Content-Type\: text/plain; echo; bash ~/.conky/scan_arp.sh" &

sleep 2
     conky -c ./.conkyrc &&
     conky -c ./.conky-dmesg &&
     conky -c ./.conky-gcal &&
     conky -c ./.conky-cal &&
     conky -c ./.conky-rings &&
     conky -c ./.conky-weather &&
     conky -c ./.conky-hosts &&
sudo conky -c ./.conky-more

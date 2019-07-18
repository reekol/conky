
sudo killall conky
sed -i "s/wlp[0-9]s0/$(iw dev | grep face | cut -d' ' -f2)/gi" ./.conkyrc
sleep 2
     conky -c ./.conkyrc &&
     conky -c ./.conky-dmesg &&
     conky -c ./.conky-gcal &&
     conky -c ./.conky-cal &&
     conky -c ./.conky-rings &&
     conky -c ./.conky-weather &&
sudo conky -c ./.conky-more

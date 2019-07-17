
sudo killall conky
sleep 2
     conky -c ./.conkyrc &&
     conky -c ./.conky-dmesg &&
     conky -c ./.conky-gcal &&
     conky -c ./.conky-cal &&
     conky -c ./.conky-rings &&
     conky -c ./.conky-weather &&
sudo conky -c ./.conky-more


killall conky
sleep 2
sudo ping -c1 -w1 127.0.0.1
conky -c ./.conkyrc &&
conky -c ./.conky-dmesg &&
conky -c ./.conky-more &&
conky -c ./.conky-cal &&
conky -c ./.conky-rings &&
conky -c ./.conky-weather

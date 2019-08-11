#!/bin/bash

trap "kill 0" EXIT


nk_clock() {
    	date +%H:%M:%S
}


nk_battery() {
    	cat /sys/class/power_supply/BAT1/capacity
}

nk_essid(){
    	iwgetid | cut -d\" -f2
}

nk_shortcut(){
       echo  "%{A:google-chrome --incognito https\://seqr.link &:}[ SeQR ]%{A}"
       echo  "%{A:google-chrome https\://github.com/reekol/conky &:}[ GitHub ReeKol ]%{A}"
       echo  "%{A:xterm -e htop &:}[ Htop ]%{A}"
}

nk_info(){
while true; do
	BAR_INPUT="Batery: $(nk_battery)%% TIME : $(nk_clock)  ESSID: $(nk_essid)"
    	echo "  "$BAR_INPUT" "$(nk_shortcut)
    	sleep 1
 done 
 }

  nk_info | lemonbar -b | bash

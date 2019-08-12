#!/bin/bash

trap "kill 0" EXIT


nk_clock() {
    	date +%H:%M:%S
}


nk_battery() {
    	cat /sys/class/power_supply/BAT*/capacity
}

nk_essid(){
    	iwgetid | cut -d\" -f2
}

nk_shortcut(){
       echo  "%{A:google-chrome --incognito https\://seqr.link &:}[ SeQR ]%{A}"
       echo  "%{A:google-chrome https\://github.com/reekol/conky &:}[ GitHub ReeKol ]%{A}"
       echo  "%{A:xterm -geometry 200x50+350+200 -e htop &:}[ Htop ]%{A}"
}

nk_info(){
while true; do
	BAR_INPUT="Batery: $(nk_battery)%% TIME : $(nk_clock)  ESSID: $(nk_essid)"
    	echo -e "  "$BAR_INPUT" %{r}"$(nk_shortcut)"%{r}"
    	sleep 1
 done 
 }

  nk_info | lemonbar -b | bash

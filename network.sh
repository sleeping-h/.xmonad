#!/bin/bash

n=`nmcli connection show --active | wc -l`
if [[ $n == 1 ]] 
	then
		echo "<fc=#888888>disconnected</fc>"
		exit 0
	fi

name=`nmcli connection show --active | awk '{ print $1 }' | tail -n 1`
device=`nmcli connection show --active | awk '{ print $4 }' | tail -n 1`

if [[ $device == eth0 ]]
	then
		echo "<icon=/home/sleeping/.xmonad/icons/wired.xbm/> $name"
	else
		echo "<icon=/home/sleeping/.xmonad/icons/wifi.xbm/> $name"
	fi

exit 0

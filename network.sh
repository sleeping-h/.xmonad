#!/bin/bash

if [[ `nmcli connection show --active | wc -l` == 1 ]] 
	then
		echo "<fc=#888888>disconnected</fc>"
		exit 0
    else 
        info=`nmcli connection show --active | tail -n 1 | sed -e 's/[[:space:]]*$//'`
	fi

case ${info## *} in
    eth*|ppp*) icon=wired.xbm ;;
    *) icon=wifi.xbm ;;
esac

echo "<icon=/home/sleeping/.xmonad/icons/$icon/> ${info%% *}"

exit 0

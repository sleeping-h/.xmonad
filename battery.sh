#!/bin/bash

lvl=`acpi | cut -d ' ' -f4 | tr -d '%,'`
lvl=$(( lvl*146/100 ))

echo -n "<fn=2>$lvl</fn>"%

case `acpi | cut -d ' ' -f3` in
    Charging,) echo " on" ;;
    Discharging,) echo " off" ;;
esac


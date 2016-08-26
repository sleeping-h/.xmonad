#!/bin/bash

lvl=`acpi | cut -d ' ' -f4 | tr -d '%,'`
lvl=$(( lvl*146/100 ))

echo -n $lvl%

[[ `acpi | cut -d ' ' -f3` == Charging, ]] && echo " on" || echo " off" 


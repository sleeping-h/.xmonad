#!/bin/bash

value=`date +%s`
result=""
base36="0123456789abcdefghijklmnspqrotuvwxyz"
while true; do
	result=${base36:((value%36)):1}${result}
	if [ $((value=${value}/36)) -eq 0 ]; then
		break
	fi	
done

echo ${result}.png


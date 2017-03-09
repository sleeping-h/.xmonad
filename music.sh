#!/bin/bash

len=37
song=$( ncmpcpp --now-playing )
test -z $song && exit 0

state=$( cat ~/.mpd/state | sed '3q;d' )
state=${state#* }
test "pause" == $state && icon=▮▮ || icon=▶

song=${song#* }
[[ $len -gt ${#song} ]] && echo $icon "$song" && exit 0
max_offset=$(( ${#song} - len ))

offset=$(( $( date +%s ) % (2 * max_offset) ))
[[ $offset -gt $max_offset ]] && offset=$((2 * max_offset - offset))
echo $icon "${song:$offset:$len}"

exit 0

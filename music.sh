#!/bin/bash

song=$( ncmpcpp --now-playing )
test -z $song && exit 0

state=$( cat ~/.mpd/state | sed '3q;d' )
state=${state#* }
test "pause" == $state && icon=▮▮ || icon=▶

song=${song#* }
[[ 30 -gt ${#song} ]] && echo $icon "$song" && exit 0 || len=30
max_offset=$(( ${#song} - len ))

offset=$(( $( date +%s ) % (2 * max_offset) ))
[[ $offset -gt $max_offset ]] && offset=$((2 * max_offset - offset))
echo $icon "${song:$offset:$len}"

exit 0

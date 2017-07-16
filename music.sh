#!/bin/bash

len=37
song=$( mpc current )
test -z "$song" && exit 0

state=$( mpc status | sed '2q;d' )
state=${state%% *}
test "[paused]" == $state && icon="<fn=1>▮▮</fn>" || icon="<fn=2>▶</fn>"

[[ $len -gt ${#song} ]] && echo $icon "$song" && exit 0
max_offset=$(( ${#song} - len ))

offset=$(( $( date +%s ) % (2 * max_offset) ))
[[ $offset -gt $max_offset ]] && offset=$((2 * max_offset - offset))
echo $icon "${song:$offset:$len}"

exit 0

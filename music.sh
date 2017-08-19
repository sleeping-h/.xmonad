#!/bin/bash

len=34
ar_len=17
song=$( mpc current )
test -z "$song" && exit 0

artist=${song%% - *}
track=${song##* - }

state=$( mpc status | sed '2q;d' )
state=${state%% *}
test "[paused]" == $state && icon="<fn=1>▮▮</fn>" || icon="<fn=2>▶</fn>"

[[ $ar_len -lt ${#artist} ]] && artist=${artist:0:$ar_len}..
[[ $len -lt $((${#track}+${#artist})) ]] && track=${track:0:$((len-${#artist}))}..
echo $icon "<fc=#eeeeff>$artist</fc>" ─ $track && exit 0

exit 0

lang=$(setxkbmap -query | awk 'END{print $2}')

if [[ $lang == us ]]
  then
    setxkbmap ru
  else
    setxkbmap us
  fi

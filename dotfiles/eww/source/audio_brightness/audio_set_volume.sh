#!/usr/bin/env bash

: '
Audio set volume
Set the volume of the default source/sink
$1=source|sink
$2=<number>|up|down|mute
$3=<amount-number?>
$4=<current_volume-number?>

@author: nguyenston
https://github.com/nguyenston
'

amount="5"
if ! [[ "$3" == "" ]]; then
  amount="$3"
fi

current_volume="0"
if ! [[ "$4" == "" ]]; then
  current_volume="$4"
fi
target=$(pactl get-default-${1})

case "$2" in
  "up")
    if [[ $((current_volume + amount)) -ge 100 ]]; then
      pactl set-${1}-volume ${target} 100%
    else
      pactl set-${1}-volume ${target} +${amount}%
    fi
    ;;
  "down")
    pactl set-${1}-volume ${target} -${amount}%
    ;;
  "mute")
    pactl set-${1}-mute ${target} toggle
    ;;
  *)
    pactl set-${1}-volume ${target} ${2}%
esac

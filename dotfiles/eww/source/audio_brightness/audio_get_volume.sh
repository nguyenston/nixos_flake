#!/usr/bin/env bash

: '
Audio get volume
return volue of default sources and sinks in json format
$1=<source|sink>
$2=<subscribe?>

@author: nguyenston
https://github.com/nguyenston
'

parse_volume='
  BEGIN {
    ret = "{"
  }

  {
    if (NR == 1) {
      ret = ret "\"left\":" substr($5, 1, length($5) - 1) ",\"right\":" substr($12, 1, length($12) - 1)
    }
    if (NR == 3) {
      ret = ret ",\"mute\":" ($2 == "yes" ? "true" : "false")
    }
  }

  END {
    ret=ret "}"
    print ret
  }
'

function get_volume_json() {
	default=$(pactl get-default-${1})
	raw_str=$(pactl get-${1}-volume ${default})
	mute_str=$(pactl get-${1}-mute ${default})
	echo -e "${raw_str}\n${mute_str}" | awk "$parse_volume"
}

# skip every n line to reduce load. might also reduce responsiveness
function every_n_line() {
	N=0
	while read -r LINE; do
		if ((N % $1 == 0)); then
			echo $LINE
		fi
		((N++))
	done
}

case "$2" in
"subscribe")
	pid=$$
	kill $(ps -ax | grep "audio_get_volume.sh $1 subscribe" | grep -v "$pid" | grep '?' | awk '{print $1}') >/dev/null 2>&1
	kill $(ps -ax | grep "pactl subscribe $1" | grep '?' | awk '{print $1}') >/dev/null 2>&1
	get_volume_json "$1"
	pactl subscribe $1 |
		grep --line-buffered "Event 'change' on $1" |
		every_n_line 1 |
		while read -r evt; do
			get_volume_json "$1"
			sleep 0.01
		done
	;;
*) get_volume_json "$1" ;;
esac

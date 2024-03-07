#!/usr/bin/env bash
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
	stdbuf -o0 grep '^monitor' | stdbuf -o0 grep -v 'HEADLESS' | while read -r line; do
	pkill wpaperd && wpaperd
	sleep 1
	ags -q && nohup ags 0<&- &>/dev/null &
done

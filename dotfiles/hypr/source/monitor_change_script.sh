#!/usr/bin/env bash
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | stdbuf -o0 grep '^monitor' | while read -r line; do
	pkill wpaperd && wpaperd
  eww close-all && eww open bar_main
done

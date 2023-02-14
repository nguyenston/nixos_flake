#!/usr/bin/env bash
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | grep 'monitor' | while read -r line; do
	wpaperd
done

#!/usr/bin/env bash
#
while true; do
	sshfs -f -o ConnectTimeout=3,ConnectionAttempts=1,ServerAliveInterval=5,ServerAliveCountMax=3 $@
	echo "disconnected from $@"
	sleep 3
	echo "retry $@ ..."
done

#!/usr/bin/env bash

sshfs -f -o ConnectTimeout=3,ConnectionAttempts=1,ServerAliveInterval=5,ServerAliveCountMax=3 $@
echo "disconnected from $@"
# while true; do
# 	sleep 3
# 	echo "retry $@ ..."
# done

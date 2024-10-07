#!/usr/bin/env bash

if [[ $(systemd-inhibit | rg -e handle-lid-switch.*block | wc -l) == 0 ]]; then
  nohup systemd-inhibit --what=handle-lid-switch sh -c "while true; do sleep 86400; done" 0<&- &>/dev/null &
fi

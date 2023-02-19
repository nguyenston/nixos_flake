#!/usr/bin/env bash
#
: '
panel opener
open a panel and close all others
$1=<panel name>
$2=horizontal|vertical
$3=<eww command>

@author: nguyenston
https://github.com/nguyenston
'
panel="$1_$2"
EWW_CMD=$3
panels=$($EWW_CMD windows)

isopen=$(echo "$panels" | grep "$panel" | grep -F '*' | wc -l)
if [[ $isopen -eq 0 ]]; then
  targets=$(echo "$panels" | grep "panel" | grep -v -E "$panel" | grep -F "*" | awk -F'*' '{print $2}')
  $EWW_CMD open $panel
  $EWW_CMD close $targets
else
  $EWW_CMD close $panel
fi


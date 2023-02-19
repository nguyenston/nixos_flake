#!/usr/bin/env bash
      

: '
Audio query
return info about sources and sinks in json format
$1=sources|sinks
$2=<eww_cmd>

@author: nguyenston
https://github.com/nguyenston
'

parse_cluster='
{
  rem = NR % 3
  if (rem == 1) {
    printf "%s,", substr($2, 2)
  }
  if (rem == 2) {
    printf "%s,", $2
  }
  if (rem == 0) {
    split($0, tokens, ": ")
    printf "%s\n", tokens[2]
  }
}
'
parse_line='
BEGIN {
  ret = "["
}

{
  ret = ret sprintf("{\"index\":%s,\"name\":\"%s\",\"description\":\"%s\"},", $1, $2, $3)
}

END {
  ret = substr(ret, 1, length(ret) - 1) "]"
  print ret
}
'

default_sink=$(pactl get-default-sink)
default_source=$(pactl get-default-source)
raw_str=$(pactl list $1 | grep -E "((Source|Sink) #|(Name|Description))")
output=$(echo "$raw_str" | awk "$parse_cluster" | awk -F',' "$parse_line")
$2 update devices="$output"

cmd="$2 update default_device='{\"sink\":\"${default_sink}\",\"source\":\"${default_source}\"}'"
eval $cmd



: '
query available wifi
returns a json string with appropriate properties

@author: nguyenston
https://github.com/nguyenston
'

function get_ssid() {
  echo "$1" | while read -r line; do
    echo "$(nmcli -f profile -t con show "$line" | grep '\.ssid' | awk -F: '{print $2}'):known:$line"
  done
}

awk_script='
BEGIN {
  ret = "["
  counter = 0
  dupe[""] = 1
}
$2 == "known" {
  known[$1] = $3
}
dupe[$3] == 0 && $2 != "known" {
  gsub("\\|", ":", $2)
  gsub("_", "", $8)
  gsub(" ", "", $8) # hyprland somehow have a differnt layout for bars
  ret = ret "{\"index\":" counter
  ret = ret ",\"active\":" ($1 == "*" ? "true" : "false")
  # ret = ret ",\"bssid\":\"" $2 "\""
  ret = ret ",\"ssid\":\"" $3 "\","
  ret = ret "\"strength\":" length($8)

  known_ssid = known[$3]
  if (known_ssid != 0)
    ret = ret ",\"security\":\"known\",\"con_name\":\"" known_ssid "\"},"
  else
    ret = ret ",\"security\":\"" $9 "\"},"

  counter++
  dupe[$3] = 1
}

END {
  ret = substr(ret, 1, length(ret) - 1) "]"
  print ret
}
'
raw_known_entries=$(nmcli -f NAME,TYPE -t con show | grep wireless | awk -F: 'BEGIN {ret = ""} 
  {ret = ret sprintf("%s\n", $1)} END {print(substr(ret, 1, length(ret)-1))}')
known_entries=$(get_ssid "$raw_known_entries")

active_entry=$(nmcli -t -c no dev wifi list | grep "^\*" | sed -e 's/\\:/|/g')
available_entries=$(nmcli -t -c no dev wifi list | sed -e 's/\\:/|/g')

augmented_str="${known_entries}\n${active_entry}\n${available_entries}"
entries=$(echo -e "$augmented_str" | awk -F: "$awk_script")

if [[ active_entry == "" ]]; then
  bars=0
else
  bars=$(echo "$active_entry" | awk -F: '{ gsub("_", "", $8); gsub(" ", "", $8); print length($8); }')
fi

echo "{\"entries\":${entries},\"bars\":${bars}}"
# notify-send "$(echo "{\"entries\":${entries},\"bars\":${bars}}")"



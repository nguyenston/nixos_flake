: '
Connect to wifi with password

@author: nguyenston
https://github.com/nguyenston
'

ssid="$1"
password="$2"
EWW_CMD="$3"
EWW_CONFIG_DIR=$4

function connect_and_update() {
  # cosmetic purposes
  ${EWW_CMD} update bars_animation=true
  ${EWW_CMD} update wifi_bars=4
  err=$(nmcli dev wifi connect "${ssid}" password "${password}" 2>&1 | grep -i -E '(error|fail)')
  if [[ "${err}" !=  "" ]]; then 
    nmcli con del "${ssid}"
    ${EWW_CMD} update wifi_msg="${err}"
  else
    notify-send "Connect to ${ssid} successful"
  fi
  ${EWW_CMD} update bars_animation=false

  # cosmetic purposes
  sleep 0.5
  current_wifi_info=$(${EWW_CMD} get wifi_info)
  ${EWW_CMD} update wifi_info="${current_wifi_info::-2}-1}"
  ${EWW_CMD} update wifi_info="$(${EWW_CONFIG_DIR}/network/query_wifi_info.sh)"
}
connect_and_update & ${EWW_CMD} update expanded_entry="{}" & ${EWW_CMD} update password=""

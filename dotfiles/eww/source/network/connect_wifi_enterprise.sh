: '
Add wpa enterprise connection
$1=<ssid>
$2=<username>
$3=<password>
$4=<auth_type>
$5=<eww_cmd>
$6=<eww_config_dir>

@author: nguyenston
https://github.com/nguyenston
'
ssid="$1"
username="$2"
password="$3"
auth="$4"
EWW_CMD="$5"
EWW_CONFIG_DIR="$6"
echo $EWW_CMD
echo $EWW_CONFIG_DIR

function connect_and_update() {
  # cosmetic purposes
  ${EWW_CMD} update bars_animation=true
  ${EWW_CMD} update wifi_bars=4

  err=$(nmcli con add \
    connection.autoconnect yes connection.autoconnect-priority 0 \
    type wifi con-name "${ssid}" ifname wlan0 ssid "${ssid}" \
    802-1x.eap "${auth}" wifi-sec.key-mgmt wpa-eap \
    802-1x.phase2-auth mschapv2 ipv6.addr-gen-mode 1 \
    802-1x.identity "${username}" 802-1x.password "${password}" \
    2>&1 | grep -i -E '(fail|error)')

  err="${err}$(nmcli con up "${ssid}" 2>&1 | grep -i -E '(fail|error)')"

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

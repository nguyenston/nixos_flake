: '
wifi bars animator
just a simple script that increments wifi_bars after a delay
$1=number
$2=<is_animating(bool)>
$3=<eww cmd>

@author: nguyenston
https://github.com/nguyenston
'

if [[ "$2" == "true" ]]; then
  sleep 0.3
  new_number=$(( $1 + 1 ))
  $3 update wifi_bars=$(( $new_number % 5 ))
else
  $3 update wifi_bars=$1
fi

#!/usr/bin/env bash
set -o pipefail

: '

Powermenu

@author: nguyenston
https://github.com/nguyenston

'

full_path=$(realpath $0)
dir_path=$(dirname $full_path)
assets=$dir_path/assets

exit_cmd="notify-send 'No suitable wm found, can't exit!'"
case "$1" in
"i3") exit_cmd="i3-msg exit" ;;
"awesome") exit_cmd="echo 'awesome.quit()' | awesome-client" ;;
"hyprland") exit_cmd="hyprctl dispatch exit" ;;
*) ;;
esac

#######################################
# construct a string of choices
choices=("Lock" "Logout" "Users" "Suspend" "Reboot" "Shutdown")
icons=("$assets/lock.svg"
	"$assets/logout.svg"
	"$assets/switch_account.svg"
	"$assets/bedtime.svg"
	"$assets/restart_alt.svg"
	"$assets/power_settings_new.svg") # Choices icon path
commands=("loginctl lock-session"
	"$exit_cmd"
	"loginctl terminate-user $USER"
	"systemctl suspend"
	"systemctl reboot"
	"systemctl poweroff")
ordering=(0 3 1 4 2 5) # swap around the ordering of the entries

choices_string=""
for i in {0..5}; do
	j=${ordering[$i]}
	choices_string+="${choices[$j]}\0icon\x1f${icons[$j]}|"
done

# prompt the user to choose what to do the the image
rofi_choice=$(echo -en "${choices_string%?}" |
	rofi -sep '|' -dmenu -i -format 'i' -p "Choose wisely..." \
		-theme "${dir_path}/options_menu.rasi" -show-icons)
rofi_exit_code=$?
rofi_choice_int=$((rofi_choice))

############################################################
# if rofi exited through keybindings set choice accordingly
if [[ $rofi_exit_code -ne 0 ]]; then
	case "$rofi_exit_code" in
	"10") eval ${commands[0]} ;; # lock
	"11") eval ${commands[1]} ;; # exit
	"12")
		sleep 1
		eval ${commands[2]}
		;;                          # users
	"13") eval ${commands[3]} ;; # suspend
	"14") eval ${commands[4]} ;; # reboot
	"15") eval ${commands[5]} ;; # shutdown
	*) exit 2 ;;                 # execution failed exit program
	esac
else
	eval ${commands[${ordering[$rofi_choice]}]}
fi

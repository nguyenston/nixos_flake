#!/usr/bin/env bash

full_path=$(realpath $0)
dir_path=$(dirname $full_path)

eww kill
eww daemon
eww open bar_main

# num_mon=$(hyprctl monitors -j | jq length)
# if [[ "${num_mon}" == "2" ]]; then
#   eww open bar_main_2
# fi

#!/usr/bin/env bash

full_path=$(realpath $0)
dir_path=$(dirname $full_path)

rofi -show drun -show-icons -icon-theme 'Papirus' -sidebar-mode -theme ${dir_path}/config.rasi

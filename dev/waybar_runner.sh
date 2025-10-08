#!/bin/bash

CONFIG_FILES="$HOME/.dotfiles/waybar/config.jsonc $HOME/.dotfiles/waybar/style.css $HOME/.dotfiles/waybar/themes/white.css"

trap "killall waybar" EXIT

while true; do
    clear
    echo "starting waybar"
    waybar &
    echo "waiting for configs to change"
    inotifywait -e create,modify $CONFIG_FILES
    echo "killing all waybar instances"
    killall waybar
done

#!/bin/bash

CONFIG_FILES="$DOTFILES_REPO_ROOT/waybar/config.jsonc $DOTFILES_REPO_ROOT/waybar/style.css $DOTFILES_REPO_ROOT/waybar/themes/white.css"

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

#!/bin/bash

CONFIG_FILES="$DOTFILES_REPO_ROOT/mako/config"

while true; do
    clear
    makoctl history | tail -n 30
    echo "waiting for configs to change"
    inotifywait -e create,modify $CONFIG_FILES
    echo "refresing mako"
    makoctl reload
    notify-send -t 2000 -u critical "crit app" -a "app"
    notify-send -t 2000 -u normal "normal fire" -a "Firefox"
done

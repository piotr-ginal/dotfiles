#!/usr/bin/env bash
d="${XDG_RUNTIME_DIR:-/tmp}"

flag_file="$d/waybar_display_block_on"

[ -e "$flag_file" ] && rm -- "$flag_file" || touch -- "$flag_file"

pkill -SIGRTMIN+12 -x waybar

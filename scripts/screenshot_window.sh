#!/bin/sh

geom="$(swaymsg -t get_tree \
  | jq -r '.. | select(.pid? and .visible?) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"' \
  | slurp -b '#00000099' -B '#00000066' -w 3 -r -c '#bfbdb6ff')" || exit 1

[ -z "$geom" ] && exit 1

grim -g "$geom" - | satty --filename -

#!/bin/sh

geom="$(swaymsg -t get_tree \
  | jq -r '.. | select(.pid? and .visible?) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"' \
  | slurp -r -c '#ff0000ff')" || exit 1

[ -z "$geom" ] && exit 1

grim -g "$geom" - | satty --filename -

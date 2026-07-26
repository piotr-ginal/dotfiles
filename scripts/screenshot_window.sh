#!/bin/sh

geom="$(swaymsg -t get_tree \
  | jq -r '.. | select((.pid? and .visible?) or .type? == "output") | select(.name != "__i3") | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"' \
  | slurp -b '#00000099' -B '#00000066' -w 3 -r -c '#bfbdb6ff')" || exit 1

[ -z "$geom" ] && exit 1

grim -g "$geom" - \
    | satty \
        --filename - \
        --output-filename "${HOME}/.screenshots/satty-%Y-%m-%d_%H:%M:%S.png" \
    | while IFS= read -r line; do
        path=$(printf '%s\n' "$line" | grep -oP "File saved to '\K[^']+(?=')")
        [ -n "$path" ] && printf '%s' "$path" | wl-copy
    done

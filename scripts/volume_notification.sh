#!/usr/bin/env bash

build_bar() {
  local percent="$1"
  local bar=""
  local fill="⠿"
  local empty="⠀"

  for (( i=1; i<=20; i++ )); do
    if (( i * 5 <= percent )); then
      bar+="$fill"
    else
      bar+="$empty"
    fi
  done

  printf '%s' "$bar"
}

volume_percentage=$(pactl get-sink-volume @DEFAULT_SINK@ | rg "(\d{1,3})%" -r '$1' -o | head -n1)

mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$mute_status" = "yes" ]; then
  mute_status_str=" (muted)"
else
  mute_status_str=""
fi


notify-send \
  --app-name="volume-notify" \
  --expire-time=1000 \
  --print-id \
  -h boolean:transient:true \
  -h string:x-canonical-private-synchronous:osd \
  "volume: $volume_percentage%$mute_status_str" "$(build_bar $volume_percentage)"

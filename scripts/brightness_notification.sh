#!/bin/bash

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

brightness_percentage=$(brightnessctl | rg "(\d{1,3})%" -o -r '$1')

notify-send \
  --app-name="brightness-notify" \
  --expire-time=1000 \
  --print-id \
  -h boolean:transient:true \
  -h string:x-canonical-private-synchronous:osd \
  "brightness: $brightness_percentage%" "$(build_bar $brightness_percentage)"

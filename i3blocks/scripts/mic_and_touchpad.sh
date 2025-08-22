#!/bin/bash


OK_COLOR="#008000"
NOK_COLOR="#FF0000"

wrap_in_span() {
  local text="$1"
  local fg="$2"
  echo "<span foreground='$fg'>$text</span>"
}

mic_mute_status=$(amixer get Capture | grep -E -o '\[on\]|\[off\]' | head -n 1)


# mic turned off is OK
if [[ "$mic_mute_status" == "[off]" ]]; then
    fg_color_mic=$OK_COLOR
else
    fg_color_mic=$NOK_COLOR
fi

touchpad_status=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="touchpad") | .libinput.send_events')

# touchpad turned off is OK
if [[ "$touchpad_status" == *enabled* ]]; then
    fg_color_touchpad=$NOK_COLOR
else
    fg_color_touchpad=$OK_COLOR
fi

echo "<span background='#0c1014'> $(wrap_in_span "M" ""$fg_color_mic"") / $(wrap_in_span "T" "$fg_color_touchpad") </span>"

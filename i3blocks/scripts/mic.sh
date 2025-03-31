#!/bin/bash

mic_mute_status=$(amixer get Capture | grep -E -o '\[on\]|\[off\]' | head -n 1)


if [[ "$mic_mute_status" == "[off]" ]]; then
    mic_status="muted"
    bg_color="#565143"
else
    mic_status="on"
    bg_color="#8B0000"
fi

echo "<span background='#232D38'> mic </span><span background='${bg_color}'> ${mic_status} </span>"

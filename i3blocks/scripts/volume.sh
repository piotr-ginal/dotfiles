#!/bin/bash

mute_status=$(amixer get Master | grep -E -o '\[on\]|\[off\]' | head -n 1)


if [[ "$mute_status" == "[off]" ]]; then
    volume="muted"
else
    volume=$(amixer get Master | grep -o '[0-9]*%' | head -n 1)
fi    

echo "<span background='#232D38'> volume </span><span background='#565143'> ${volume} </span>"

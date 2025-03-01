#!/bin/bash

minimal_warning=15
minimal_warning_critical=10

battery=$(cat /sys/class/power_supply/BAT1/capacity)

if [ "$battery" -le "$minimal_warning" ]; then
    if [ "$battery" -le "$minimal_warning_critical" ]; then
        background_color="#FF0000"
    else
        background_color="#FF4D00"
    fi
else
    background_color="#565143"
fi

battery_status=$(cat /sys/class/power_supply/BAT1/status)

if [[ "$battery_status" == "Charging" ]]; then
    background_color="#008000"
fi

echo "<span background='#232D38'> bat </span><span background='${background_color}'> ${battery} </span>"

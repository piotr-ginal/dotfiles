#!/bin/bash

minimal_warning=15
minimal_warning_critical=10

notification_state_file="/tmp/battery_notification_state"

battery=$(cat /sys/class/power_supply/BAT*/capacity)

battery_status=$(cat /sys/class/power_supply/BAT*/status)

if [ "$battery" -le "$minimal_warning" ]; then
    if [ "$battery" -le "$minimal_warning_critical" ]; then
        background_color="#FF0000"
    else
        background_color="#FF4D00"
    fi
else
    background_color="#0F1419"
fi

if [[ "$battery_status" == "Charging" ]]; then
    background_color="#008000"
    rm -f "$notification_state_file"
else
    if [ "$battery" -le "$minimal_warning" ] && [ ! -f "$notification_state_file" ]; then
        if [ "$battery" -le "$minimal_warning_critical" ]; then
            notify-send -u critical "Battery Critical" "Battery level is critically low"
        else
            notify-send -u normal -t 2000 "Battery Warning" "Battery level is low"
        fi

        touch "$notification_state_file"
    fi
fi

echo "<span background='#232D38'> bat </span><span background='${background_color}'> ${battery} </span>"

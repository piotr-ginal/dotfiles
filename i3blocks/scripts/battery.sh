#!/bin/bash

minimal_warning=15
minimal_warning_critical=10

notification_state_normal="/tmp/battery_notification_state_normal"
notification_state_critical="/tmp/battery_notification_state_critical"

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
    rm -f "$notification_state_normal" "$notification_state_critical"
else
    if [ "$battery" -le "$minimal_warning_critical" ] && [ ! -f "$notification_state_critical" ]; then
        notify-send -u critical "Battery Critical" "Battery level is critically low"
        touch "$notification_state_critical"
    elif [ "$battery" -le "$minimal_warning" ] && [ ! -f "$notification_state_normal" ]; then
        notify-send -u normal -t 5000 "Battery Warning" "Battery level is low"
        touch "$notification_state_normal"
    fi
fi

echo "<span background='#232D38'> bat </span><span background='${background_color}'> ${battery} </span>"

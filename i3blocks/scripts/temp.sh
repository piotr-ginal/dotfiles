#!/bin/bash

temperature=$(awk '{print $1 / 1000}' /sys/class/thermal/thermal_zone0/temp)

minimal_warning=55
minimal_warning_critical=80

if [ "$temperature" -ge "$minimal_warning_critical" ]; then
    background_color="#FF0000"  # Critical temperature
elif [ "$temperature" -ge "$minimal_warning" ]; then
    background_color="#FF4D00"  # Warning temperature
else
    background_color="#565143"   # Normal temperature
fi

echo "<span background='#232D38'> CPU </span><span background='${background_color}'> ${temperature}°C </span>"

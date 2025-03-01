#!/bin/bash

network=$(/sbin/iwconfig 2>/dev/null | grep -oE 'ESSID:".*"' | sed 's/ESSID://g' | sed 's/"//g' || echo "disconnected")

if [[ -n "$network" ]]
then
    echo "<span background='#232D38'> wifi </span><span background='#565143'> ${network} </span>"
else
    echo "<span background='#232D38'> wifi </span><span background='#565143'> disconnected </span>"
fi


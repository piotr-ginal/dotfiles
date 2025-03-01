#!/bin/bash

load=$(awk '{print $1}' /proc/loadavg)

echo "<span background='#232D38'> load </span><span background='#565143'> ${load} </span>"

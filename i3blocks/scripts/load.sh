#!/bin/bash

load=$(awk '{print $1}' /proc/loadavg)

echo "<span background='#232D38'> load </span><span background='#0F1419'> ${load} </span>"

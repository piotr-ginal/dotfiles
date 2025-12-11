#!/usr/bin/env bash

output_filename="$HOME/.screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png"

grimshot save area $output_filename &> /dev/null

[ $? -ne 0 ] && exit 0

notify-send -a screenshot-notification "Screenshot saved" $(basename $output_filename)

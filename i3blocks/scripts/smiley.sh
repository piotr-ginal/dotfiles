#!/bin/bash

STATE_FILE="/tmp/i3face_state"

faces=("(•‿•)" "(^‿•)")

if [[ -f "$STATE_FILE" ]]; then
  index=$(cat "$STATE_FILE")
else
  index=0
fi

next_index=$(( (index + 1) % ${#faces[@]} ))

echo "${faces[$index]}"

echo "$next_index" > "$STATE_FILE"

if [[ "$index" -eq 0 ]]; then
  sleep 0.5
else
  sleep 10
fi

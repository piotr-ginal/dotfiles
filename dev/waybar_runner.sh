#!/bin/bash

if ! type inotifywait &>/dev/null; then
  echo "error: inotifywait not found in PATH" >&2
  exit 1
fi

while true; do
  pgrep -x waybar &>/dev/null || setsid waybar >/dev/null 2>&1 &
  inotifywait -e create,modify -r "$DOTFILES_REPO_ROOT/waybar" 2>/dev/null || {
      echo "failed to establish watch"
      exit 1
  }
  killall -SIGUSR2 waybar
done

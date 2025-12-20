#!/usr/bin/env sh

if ! command -v hyperfine >/dev/null 2>&1; then
  echo "error: hyperfine is not installed."
  exit 1
fi

hyperfine -w 1 -m 20 'zsh -i -c exit'

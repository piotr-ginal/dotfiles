#!/usr/bin/env bash

export PATH="$HOME/.nvm/versions/node/v25.1.0/bin:$PATH"
copilot "$@"
exec zsh

#!/bin/bash

sudo apt update
sudo apt install pipx
pipx install --include-deps ansible-core

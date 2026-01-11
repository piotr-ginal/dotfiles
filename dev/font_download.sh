#!/usr/bin/env bash

FONT_DIR="${HOME}/.local/share/fonts"
VERSION="v3.4.0"
BASE_URL="https://github.com/ryanoasis/nerd-fonts/raw/refs/tags/${VERSION}/patched-fonts/JetBrainsMono/NoLigatures"

mkdir -p "${FONT_DIR}"

declare -a FONTS=(
    "Bold/JetBrainsMonoNLNerdFontMono-Bold.ttf"
    "Regular/JetBrainsMonoNLNerdFontMono-Regular.ttf"
    "Italic/JetBrainsMonoNLNerdFontMono-Italic.ttf"
)

for font in "${FONTS[@]}"; do
    wget -q --show-progress -nc -P "${FONT_DIR}" "${BASE_URL}/${font}"
done

fc-cache -fv "${FONT_DIR}"

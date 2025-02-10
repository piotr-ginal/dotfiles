#!/bin/bash

# ---- helix config and languages config ----
HELIX_CONFIG_DIR="$HOME/.config/helix"
for file in config.toml languages.toml; do
    TARGET="$HELIX_CONFIG_DIR/$file"
    SOURCE="$(pwd)/helix/$file"
    if [[ -L "$TARGET" && "$(readlink "$TARGET")" != "$SOURCE" ]]; then
        rm "$TARGET"
    fi
    if [[ ! -e "$TARGET" ]]; then
        ln -s "$SOURCE" "$TARGET"
        echo "Created symbolic link for $file."
    else
        echo "Symbolic link for $file already exists."
    fi
done

# ---- ZSH_CUSTOM configuration ----
ZSH_CUSTOM_LINE="ZSH_CUSTOM=$(pwd)/zsh_custom"
SOURCE_OH_MY_ZSH_LINE="source \$ZSH/oh-my-zsh.sh"

if [[ ! -f "$HOME/.zshrc" ]]; then
    echo "Warning: .zshrc file does not exist. Skipping ZSH_CUSTOM configuration."
else
    if grep -q '^ZSH_CUSTOM=' "$HOME/.zshrc"; then
        sed -i 's|^ZSH_CUSTOM=.*|'"$ZSH_CUSTOM_LINE"'|' "$HOME/.zshrc"
        echo "Updated ZSH_CUSTOM in .zshrc."
    else
        if grep -q "$SOURCE_OH_MY_ZSH_LINE" "$HOME/.zshrc"; then
            ESCAPED_SOURCE_OH_MY_ZSH_LINE=$(echo "$SOURCE_OH_MY_ZSH_LINE" | sed 's/[\/&]/\\&/g')
            sed -i "/${ESCAPED_SOURCE_OH_MY_ZSH_LINE}/i ${ZSH_CUSTOM_LINE}" "$HOME/.zshrc"
            echo "Added ZSH_CUSTOM to .zshrc before sourcing oh-my-zsh."
        else
            echo "$SOURCE_OH_MY_ZSH_LINE not found in .zshrc"
        fi
    fi
fi

# ---- GIT_CONFIG configuration ----
GIT_CONFIG_PATH="$(pwd)/git_config"

if [[ ! -f "$HOME/.gitconfig" ]]; then
    echo "Warning: .gitconfig file does not exist, creating a new one"
    touch "$HOME/.gitconfig"
fi

if ! grep -q "\[include\]" "$HOME/.gitconfig" || ! grep -q "path = ${GIT_CONFIG_PATH}" "$HOME/.gitconfig"; then
    cat <<EOF >> "$HOME/.gitconfig"
[include]
        path = ${GIT_CONFIG_PATH}
EOF
    echo "Added include path to .gitconfig."
else
    echo "Include path already exists in .gitconfig."
fi

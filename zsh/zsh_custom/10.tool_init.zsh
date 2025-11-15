# tools setup - does not include configuration

# ---- fzf (for zsh) ----
command -v fzf &>/dev/null && source <(fzf --zsh)

# ---- rust -----
[ -f "$HOME/.cargo/env" ] && source $HOME/.cargo/env

# ---- editor ----
export EDITOR=hx

# ---- helix ----
export HELIX_RUNTIME="$HOME/.config/helix_runtime"

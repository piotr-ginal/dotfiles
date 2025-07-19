# tools setup - does not include configuration

# ---- pyenv ----
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  export PATH=$(pyenv root)/shims:$PATH
fi

# ---- fzf (for zsh) ----
command -v fzf &>/dev/null && source <(fzf --zsh)

# ---- rust -----
[ -f "$HOME/.cargo/env" ] && source $HOME/.cargo/env

# ---- editor ----
export EDITOR=hx

# ---- helix ----
export HELIX_RUNTIME="$HOME/.config/helix_runtime"

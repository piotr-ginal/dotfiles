# tools setup - does not include configuration

# ---- pyenv ----
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH=$(pyenv root)/shims:$PATH

# ---- fzf (for zsh) ----
source <(fzf --zsh)

# ---- rust -----
source $HOME/.cargo/env

# ---- editor ----
export EDITOR=hx

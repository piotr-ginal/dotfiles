setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt interactive_comments

# ---- history ----
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS

unsetopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS

HISTFILE="$HOME/.zsh_history"   # no export
HISTSIZE=200000
SAVEHIST=100000

# ---- misc ----
# Specifies the non-alphanumeric characters treated as part of a word during line editing.
export WORDCHARS='_-'

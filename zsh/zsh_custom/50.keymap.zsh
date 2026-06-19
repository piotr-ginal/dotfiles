# man terminfo - key codes (kcuu1, kcud1 ...)
# man zshcontrib - widgets used below
bindkey -e

autoload -U edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey -M emacs "${terminfo[kcuu1]:-^[[A}" up-line-or-beginning-search  # kcuu1: up-arrow key

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M emacs "${terminfo[kcud1]:-^[[B}" down-line-or-beginning-search  # kcud1: down-arrow key

bindkey -M emacs "${terminfo[kcub1]:-^[[1;5C}" forward-word  # kcub1: left-arrow key
bindkey -M emacs "${terminfo[kcuf1]:-^[[1;5D}" backward-word  # kcuf1: right-arrow key

bindkey '^[[Z' reverse-menu-complete

bindkey -e

autoload -U edit-command-line
zle -N edit-command-line
bindkey "^E" edit-command-line

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey -M emacs "${terminfo[kcuu1]:-^[[A}" up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M emacs "${terminfo[kcud1]:-^[[B}" down-line-or-beginning-search

bindkey -M emacs '^[[1;5C' forward-word
bindkey -M emacs '^[[1;5D' backward-word

bindkey '^[[Z' reverse-menu-complete

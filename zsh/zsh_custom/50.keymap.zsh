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

# ctrl+arrow has no standard terminfo capability; kcub1/kcuf1 are the
# plain (unmodified) arrow keys only. modifier combos (klft5/krit5 for
# ctrl) are an ncurses/xterm extension, not part of x/open curses, and
# aren't guaranteed to be defined for every terminal entry.
bindkey -M emacs "^[[1;5C" forward-word
bindkey -M emacs "^[[1;5D" backward-word

bindkey '^[[Z' reverse-menu-complete

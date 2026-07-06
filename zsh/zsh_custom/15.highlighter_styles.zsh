# ---- zsh syntax highlighting ----

# defined style keys can be mainly found in
# zsh-syntax-highlighting/docs/highlighters/main.md
# (this file is available in ~/.zcomet/repos/zsh-users)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='bold'
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[redirection]='bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=246'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=153'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=38'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=38'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=38'

ZSH_HIGHLIGHT_STYLES[precommand]='fg=153,underline'

ZSH_HIGHLIGHT_STYLES[autodirectory]=none

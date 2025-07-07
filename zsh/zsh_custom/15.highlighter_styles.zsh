# ---- zsh syntax highlighting ----

# defaults can be found in
# /usr/share/zsh-syntax-highlighting/highlighters/main/main-highlighter.zsh

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


# ---- zsh colored man pages ----
# defaults can be found in colored-man-pages zsh plugin source
less_termcap[md]=$'\e[1;38;2;32;175;193m'  # bold & blinking mode - 20AFC1, bold
less_termcap[us]=$'\e[38;2;28;155;172m'  # underlining - 1C9BAC, normal

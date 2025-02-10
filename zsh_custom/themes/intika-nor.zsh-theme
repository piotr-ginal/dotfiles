ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[red]%{$reset_color%} ✗"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%} ±%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} ▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%} ▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%}"


function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}


function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh) "
  fi
}


PROMPT='$(ssh_connection)%{$fg[white]%}[%T][%m:%n%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}%{$fg[white]%}$(git_prompt_info)]
$(prompt_char)%{$reset_color%} '


RPROMPT=''

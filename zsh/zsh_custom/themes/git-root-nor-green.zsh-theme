ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[red]%{$reset_color%} ✗"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%} ±%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} ▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%} ▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%}"


PROMPT_TIME_COLOR="%{$fg[white]%}"
PROMPT_CWD_COLOR="%{$reset_color%}"
PROMPT_GIT_COLOR="%{$fg[white]%}"
RESET_COLOR="%{$reset_color%}"

function prompt_char {
  if [ $UID -eq 0 ]; then
    echo "#"
  else
    echo "$"
  fi
}

function ssh_connection {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh) "
  fi
}

function git_prompt_info_with_root {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -n "$root" && -w "$root/.git" ]]; then
    if [[ "$PWD" != "$root" ]]; then
      echo " (${PROMPT_GIT_COLOR}$(basename "$root") "
    else
      echo " (${PROMPT_GIT_COLOR}"
    fi
  fi
}

function build_ssh_segment {
  echo -n "$(ssh_connection)"
}

function build_time_segment {
  echo -n "[${PROMPT_TIME_COLOR}%T${RESET_COLOR}]"
}

function build_host_segment {
  echo -n "[${PROMPT_TIME_COLOR}%m:%n${RESET_COLOR}"
}

function build_cwd_segment {
  echo -n "${PROMPT_CWD_COLOR}%c${RESET_COLOR}"
}

function build_git_segment {
  echo -n "$(git_prompt_info_with_root)"
}

function build_prompt_char_segment {
  echo -n "$(prompt_char)"
}

function assemble_prompt {
  local SSH_SEGMENT TIME_SEGMENT HOST_SEGMENT CWD_SEGMENT GIT_SEGMENT PROMPT_CHAR_SEGMENT

  SSH_SEGMENT='$(build_ssh_segment)'
  TIME_SEGMENT='$(build_time_segment)'
  HOST_SEGMENT='$(build_host_segment)'
  CWD_SEGMENT='$(build_cwd_segment)'
  GIT_SEGMENT='$(build_git_segment)$(git_prompt_info)${RESET_COLOR}]'
  PROMPT_CHAR_SEGMENT='$(build_prompt_char_segment)'

  PROMPT="${SSH_SEGMENT}${TIME_SEGMENT}${HOST_SEGMENT}:${CWD_SEGMENT}${GIT_SEGMENT}
${PROMPT_CHAR_SEGMENT}${RESET_COLOR} "
}

assemble_prompt
RPROMPT=''

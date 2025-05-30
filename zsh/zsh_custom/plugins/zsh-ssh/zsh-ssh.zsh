#!/usr/bin/env zsh
# github.com/sunlei/zsh-ssh

setopt no_beep

SSH_CONFIG_FILE="${SSH_CONFIG_FILE:-$HOME/.ssh/config}"

_parse_config_file() {
  setopt localoptions rematchpcre
  unsetopt nomatch

  local config_file_path=$(realpath "$1")
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ ^[Ii]nclude[[:space:]]+(.*) ]] && (( $#match > 0 )); then
      local include_path="${match[1]}"
      if [[ $include_path == ~* ]]; then
        local expanded_include_path=${include_path/#\~/$HOME}
      else
        local expanded_include_path="$HOME/.ssh/$include_path"
      fi
      for include_file_path in $~expanded_include_path; do
        if [[ -f "$include_file_path" ]]; then
          echo ""
          _parse_config_file "$include_file_path"
        fi
      done
    else
      echo "$line"
    fi
  done < "$config_file_path"
}

_ssh_host_list() {
  local ssh_config host_list

  ssh_config=$(_parse_config_file $SSH_CONFIG_FILE)
  ssh_config=$(echo $ssh_config | command grep -v -E "^\s*#[^_]")

  host_list=$(echo $ssh_config | command awk '
    function join(array, start, end, sep, result, i) {
      if (sep == "")
        sep = " "
      else if (sep == SUBSEP) # magic value
        sep = ""
      result = array[start]
      for (i = start + 1; i <= end; i++)
        result = result sep array[i]
      return result
    }

    function parse_line(line) {
      n = split(line, line_array, " ")

      key = line_array[1]
      value = join(line_array, 2, n)

      return key "#-#" value
    }

    function contains_star(str) {
        return index(str, "*") > 0
    }

    function starts_or_ends_with_star(str) {
        start_char = substr(str, 1, 1)
        end_char = substr(str, length(str), 1)

        return start_char == "*" || end_char == "*"
    }

    BEGIN {
      IGNORECASE = 1
      FS="\n"
      RS=""

      host_list = ""
    }
    {
      match_directive = ""

      user = " "
      host_name = ""
      alias = ""
      desc = ""
      desc_formated = " "

      for (line_num = 1; line_num <= NF; ++line_num) {
        line = parse_line($line_num)

        split(line, tmp, "#-#")

        key = tolower(tmp[1])
        value = tmp[2]

        if (key == "match") { match_directive = value }

        if (key == "host") { aliases = value }
        if (key == "user") { user = value }
        if (key == "hostname") { host_name = value }
        if (key == "#_desc") { desc = value }
      }

      split(aliases, alias_list, " ")
      for (i in alias_list) {
        alias = alias_list[i]

        if (!host_name && alias ) {
          host_name = alias
        }

        if (desc) {
          desc_formated = sprintf("[\033[00;34m%s\033[0m]", desc)
        }

        if ((host_name && !starts_or_ends_with_star(host_name)) && (alias && !starts_or_ends_with_star(alias)) && !match_directive) {
          host = sprintf("%s|->|%s|%s|%s\n", alias, host_name, user, desc_formated)
          host_list = host_list host
        }
      }
    }
    END {
      print host_list
    }
  ')

  for arg in "$@"; do
    case $arg in
    -*) shift;;
    *) break;;
    esac
  done

  host_list=$(command grep -i "$1" <<< "$host_list")
  host_list=$(echo $host_list | command sort -u)

  echo $host_list
}


_fzf_list_generator() {
  local header host_list

  if [ -n "$1" ]; then
    host_list="$1"
  else
    host_list=$(_ssh_host_list)
  fi

  header="
Alias|->|Hostname|User|Desc
─────|──|────────|────|────
"

  host_list="${header}\n${host_list}"

  echo $host_list | command column -t -s '|'
}

_set_lbuffer() {
  local result selected_host connect_cmd is_fzf_result
  result="$1"
  is_fzf_result="$2"

  if [ "$is_fzf_result" = false ] ; then
    result=$(cut -f 1 -d "|" <<< ${result})
  fi

  selected_host=$(cut -f 1 -d " " <<< ${result})
  connect_cmd="ssh ${selected_host}"

  LBUFFER="$connect_cmd"
}

fzf_complete_ssh() {
  local tokens cmd result selected_host
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins

  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}

  if [[ "$LBUFFER" =~ "^ *ssh$" ]]; then
    zle ${fzf_ssh_default_completion:-expand-or-complete}
  elif [[ "$cmd" == "ssh" ]]; then
    result=$(_ssh_host_list ${tokens[2, -1]})
    fuzzy_input="${LBUFFER#"$tokens[1] "}"

    if [ -z "$result" ]; then
      zle ${fzf_ssh_default_completion:-expand-or-complete}
      return
    fi

    if [ $(echo $result | wc -l) -eq 1 ]; then
      _set_lbuffer $result false
      zle reset-prompt
      return
    fi

    result=$(_fzf_list_generator $result | grep -vF ":ignore:" | fzf \
      --height 40% \
      --ansi \
      --border \
      --cycle \
      --info=inline \
      --header-lines=2 \
      --reverse \
      --prompt='SSH Remote > ' \
      --query=$fuzzy_input \
      --no-separator \
      --bind 'shift-tab:up,tab:down,bspace:backward-delete-char/eof' \
      --preview 'ssh -T -G $(cut -f 1 -d " " <<< {}) | grep -i -E "^User |^HostName |^Port |^ControlMaster |^ForwardAgent |^LocalForward |^IdentityFile |^RemoteForward |^ProxyCommand |^ProxyJump " | column -t' \
      --preview-window=right:40%
    )

    if [ -n "$result" ]; then
      _set_lbuffer $result true
      zle -R
    fi

    zle reset-prompt

  else
    zle ${fzf_ssh_default_completion:-expand-or-complete}
  fi
}

[ -z "$fzf_ssh_default_completion" ] && {
  binding=$(bindkey '^I')
  [[ $binding =~ 'undefined-key' ]] || fzf_ssh_default_completion=$binding[(s: :w)2]
  unset binding
}

zle -N fzf_complete_ssh
bindkey '^I' fzf_complete_ssh

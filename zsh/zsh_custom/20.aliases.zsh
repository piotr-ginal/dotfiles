# ---- git command functions ----
short_log_command_git() {
  local n
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    n=$1
    shift
  else
    n=10
  fi
  git --no-pager log --oneline -n "$n" "$@"
}

short_log_command_git_names() {
  git --no-pager log --oneline --name-only -n ${1:-10}
}

git_add_and_commit_command() {
  NO_FILENAMES_MESSAGE="Please enter files to be added to the commit"

  filenames_for_git=()
  options_for_git=()
  files_ahead=true

  for argument in "$@"; do
    if [[ "$argument" == -* ]]; then
      files_ahead=false
    fi

    if $files_ahead; then
      filenames_for_git+=("$argument")
    else
      options_for_git+=("$argument")
    fi
  done

  if [[ ${#filenames_for_git[@]} -eq 0 ]]; then
    echo "$NO_FILENAMES_MESSAGE"
    return 1
  fi

  git add -p "${filenames_for_git[@]}"
  git commit "${options_for_git[@]}"
}

git_status_rg() {
  if [[ -z "$1" ]]; then
    echo "error: no regex provided"
    return 1
  fi
  git status --short | rg "$1"
}

git_status_fzf() {
  if [[ -z "$1" ]]; then
    echo "error: no regex provided"
    return 1
  fi
  git_status_rg "$1" | fzf --exit-0 --multi --height=~40% --bind 'ctrl-a:select-all,ctrl-d:deselect-all' | cut -c4- | awk '{
    if (match($0, /^.+-> +(.+)$/, m)) {
      print m[1]
    } else {
      print
    }
  }' # handle renames - return just the new filename
}

fzf_git_add_changed_file() {
  local files
  files=$(git_status_fzf "^.[^ ]")
  if [ -n "$files" ]; then
    git add "${(f)files}" "$@"
  fi
}

fzf_git_patch_add_changed_file() {
  local files
  files=$(git_status_fzf "^.M")
  if [ -n "$files" ]; then
    git add -p "${(f)files}" "$@"
  fi
}

fzf_git_remove_untracked_file() {
  local files
  files=$(git_status_fzf "^\?\?")
  if [ -n "$files" ]; then
    rm "${(f)files}" "$@"
  fi
}

fzf_git_diff() {
  local files
  files=$(git_status_fzf "^.[^ ?]")
  if [ -n "$files" ]; then
    git diff "${(f)files}" "$@"
  fi
}

fzf_git_switch() {
  local branch
  branch=$(git branch --list --color | fzf --ansi --height=~40% | awk '{print $NF}')
  if [ -n "$branch" ]; then
    git switch "$branch"
  fi
}

git_delta_pager_toggle_feature () {
  eval "export DELTA_FEATURES='$(delta_features_toggle $1)'"
}

git_log_interactive() {
  local selected=$(git log -n 100 --pretty=format:'%h %s' "$@" | \
    fzf --ansi \
        --preview 'git show {1} --pretty=format: | delta --paging=never' \
        --preview-window=right:60% \
        --delimiter=' ' \
        --with-nth=1,2.. \
        --layout=reverse \
        --header-label ' commit ' \
        --bind 'focus:+bg-transform-header:if [[ -n {} ]]; then
                  git show {1} -q | head -n5 | delta --paging=never
                fi' \
        --bind "ctrl-d:preview-down,ctrl-u:preview-up")

  if [[ -z $selected ]]; then
    return 1
  fi

  local short_hash="${selected%% *}"
  local full_hash=$(git rev-parse "$short_hash")

  echo "$full_hash"
}

# ---- ps aliases ----
alias psall="ps aux"
alias pstree="ps axjf"

# ---- pyenv command functions ----
create_pyenv_virtualenv() {
  if [ $# -eq 1 ]; then
    local env_name="$1"
    echo "using $(pyenv global), no version supplied for '$env_name'."
    pyenv virtualenv "$env_name"
  elif [ $# -eq 2 ]; then
    pyenv virtualenv "$1" "$2"
  else
    echo "Error: mkenv requires 1 or 2 arguments"
    echo "    mkenv <name> (uses pyenv global Python version)"
    echo "    mkenv <python version> <name>"
    return 1
  fi
}

activate_pyenv_virtualenv() {
  if [ $# -ne 1 ]; then
    echo "Error: acenv requires 1 argument"
    echo "      acenv <name>"
    return 1
  fi
  pyenv activate "$1"
}

delete_pyenv_virtualenv() {
  if [ $# -ne 1 ]; then
    echo "Error: rmenv requires 1 argument"
    echo "      rmenv <name>"
    return 1
  fi
  pyenv virtualenv-delete -f "$1"
}

activate_pyenv_environment() {
  local selected_env
  selected_env=$(lsenv 2>&1 | awk '{print $2}' | fzf --height=~40% --layout=reverse --info inline)

  if [[ -n "$selected_env" ]]; then
    pyenv activate "$selected_env"
  fi
}

remove_pyenv_environment() {
  local selected_env
  selected_env=$(lsenv 2>&1 | awk '{print $2}' | fzf --height=~40% --layout=reverse --info inline)

  if [[ -n "$selected_env" ]]; then
    pyenv virtualenv-delete -f "$selected_env"
  fi
}

# ---- misc functions ----
rg_with_delta() {
  local pattern="$1"
  shift  # move arguments in place - 'use' $1 (the pattern)
  rg --json -C 2 "$pattern" "$@" | delta
}

yazi_wrapper_change_pwd() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# ---- git aliases ----
alias shlog=short_log_command_git
alias shlogn=short_log_command_git_names
alias gac=git_add_and_commit_command
alias gurl='convert_git_remotes_ssh_to_http'
alias opgurl='open_git_remote_browser'
alias gb="git --no-pager branch"
alias reporoot="git rev-parse --show-toplevel"
alias rpwd='echo $(git rev-parse --show-toplevel | xargs -I{} realpath --relative-to={} .)'
alias gap="git add -p"
alias glog='git log --all --graph --pretty="format:%C(blue)%h %C(white) %an %ar%C(auto) %D%n%s%n"'
alias glogi="DELTA_FEATURES=+line-numbers git_log_interactive"
alias gaf="fzf_git_add_changed_file"
alias gafp="fzf_git_patch_add_changed_file"
alias rmn="fzf_git_remove_untracked_file"
alias dtgl=git_delta_pager_toggle_feature
alias gswf=fzf_git_switch
alias gdf=fzf_git_diff

unalias grs

# ---- github aliases ----
github_search_repo_fzf() {
  gh search repos --json fullName,stargazersCount,description "$@" \
    | jq -r '.[] | "\(.fullName) [\(.stargazersCount)] \(.description)"' \
    | fzf --prompt="Select repository: " \
    | sed -E 's/ \[[0-9]+\]$//'
}
alias ghinv="gh_accept_invitation"
alias ghcolabls="gh_collaborator_repo"
alias ghrepols="gh repo list --json nameWithOwner -L 1000 --jq '.[].nameWithOwner' | fzf --height=~40%"
alias ghcl='repo_name=$(ghrepols) && [ -n $repo_name ] && gh repo clone $repo_name'
alias ghclcol='repo_name=$(gh_collaborator_repo) && [ -n $repo_name ] && gh repo clone $repo_name'
alias ghf=github_search_repo_fzf

# ---- pyenv virtualenv aliases ----
alias rmenv=delete_pyenv_virtualenv
alias mkenv=create_pyenv_virtualenv
alias acenv=activate_pyenv_virtualenv
alias ac='activate_pyenv_environment'
alias rme='remove_pyenv_environment'
alias lsenv='pyenv virtualenvs --bare --skip-aliases | rg ".envs." -r " "'
alias deenv="source deactivate"
alias envpurge='pyenv virtualenvs --bare --skip-aliases | grep -E "[^\/]+$" -o --color=never | xargs -d "\n" -I {} pyenv virtualenv-delete -f {}'; alias purgeenv=envpurge

# ---- python aliases ----
alias upip='python -m pip install --upgrade pip'
alias rmpyc='find . -name "*.pyc" -delete'
alias pinst='python -m pip install'
alias puninst='python -m pip uninstall'
alias pippurge='python -m pip freeze > /tmp/pippurge.txt; if [ -s /tmp/pippurge.txt ]; then python -m pip uninstall -r /tmp/pippurge.txt -y; else echo "Pip freeze is empty, no need to uninstall anything"; fi; rm /tmp/pippurge.txt'; alias purgepip=pippurge;
alias versions="python -m pip --disable-pip-version-check index versions $1 2>/dev/null"
alias pyclean="find . \( -name __pycache__ -o -name .ruff_cache -o -name .mypy_cache -o -name .pytest_cache \) -exec rm -r {} +"; alias cleanpy=pyclean;

# ---- misc aliases ----
alias c=clear
alias bat="batcat"
alias forall='do_for_all() { for d in */; do (cd "$d" && eval "$@"); done }; do_for_all' # execute command in each child directory eg forall "ls && gst"
alias fb="fzf --preview 'batcat {} --color=always' --height=45%"
alias f='selected_dir=$(fdfind --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv | fzf --height=55% --preview "eza --color=always {}" --preview-window=down:50%) && [ -n "$selected_dir" ] && cd "$selected_dir"'
alias rmproxy="export http_proxy= && export https_proxy= && export HTTP_PROXY= && export HTTPS_PROXY="
alias cppwd='pwd | copy'
alias curs="printf '\033[0 q'"
alias cdd="dir=\$(d | fzf --height=~40% | awk '{ print \$1 }') && [ -n \"\$dir\" ] && cd -\$dir"
alias rgg=rg_with_delta
alias cppass=keepassxc_select_and_copy_password
alias perms='stat --printf="%04a %A %U:%G %n\n"'
alias fd=fdfind
alias y=yazi_wrapper_change_pwd

# ---- zsh aliases ----
alias reload="source ~/.zshrc"

# ---- editor aliases ----
fzf_helix_open_files() {
  local files
  files=$(fd --type f . | fzf --multi --height=~40% --bind 'ctrl-a:select-all,ctrl-d:deselect-all')
  if [[ -n "$files" ]]; then
    hx ${(f)files}
  fi
}
fzf_helix_git_changed_open_file() {
  local files
  # all files except deleted
  files=$(git_status_fzf "^[^D]{2}")
  if [ -n "$files" ]; then
    hx "${(f)files}" "$@"
  fi
}
alias h=hx
alias op="fzf_helix_open_files"
alias opr="fzf_regex_open"
alias opc="fzf_helix_git_changed_open_file"

# ---- system aliases ----
alias copy="sed -z '$ s/\n$//' | wl-copy"
alias rescan="nmcli device wifi list --rescan yes"
alias scanfor=wait_for_wifi_network
alias reboot="sudo reboot"
alias lock="swaylock -c 000000"
cpp() { realpath "$@" | copy; }

# ---- cd aliases ----
alias dot="cd $DOTFILES_REPO_ROOT"
alias rec="cd ~/.screenrecordings"
alias scr="cd ~/.screenshots"

# ---- ls aliases ----
alias ls='eza'
alias l='eza --icons -lah'
alias la='eza --icons -lAh'
alias lt='eza --icons -T'
alias ll='eza --icons -lh'

# ---- docker aliases ----
alias dbuild="docker build"
alias dcls="docker container list"
alias dexe="docker exec -it -e COLORTERM"
alias dils="docker image list"
alias dlog="docker logs"
alias dps="docker ps -a"
alias drun="docker run"
alias dstop="docker stop"

# ---- google service aliases ----
alias gmail="open_google_service_with_account https://mail.google.com/mail/u/"
alias gdocs="open_google_service_with_account https://docs.google.com/document/u/"
alias gdrive="open_google_service_with_account https://drive.google.com/drive/u/"
alias gcal="open_google_service_with_account https://calendar.google.com/calendar/u/"

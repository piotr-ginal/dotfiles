# ---- git command functions ----
short_log_command_git() {
  git --no-pager log --oneline -n ${1:-10}
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

# ---- ps aliases ----
alias psall="ps aux"
alias pstree="ps axjf"

# --- pyenv command functions ----
create_pyenv_virtualenv() {
  if [ $# -ne 2 ]; then
    echo "Error: mkenv requires 2 arguments"
    echo "	mkenv <python version> <name>"
    return 1
  fi
  pyenv virtualenv "$1" "$2"
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

# ---- git aliases ----
alias shlog=short_log_command_git
alias shlogn=short_log_command_git_names
alias gac=git_add_and_commit_command
alias gurl='git remote get-url origin | rg : -r / | rg -e "git@" -r "https://" --color never | rg -e "\.git$" -r ""'
alias opgurl='gurl | xargs firefox'
alias gb="git --no-pager branch"
alias reporoot="git rev-parse --show-toplevel"
alias cdroot='cd `reporoot`'  # single quotes for runtime evaluation

# ---- pyenv virtualenv aliases ----
alias rmenv=delete_pyenv_virtualenv
alias mkenv=create_pyenv_virtualenv
alias acenv=activate_pyenv_virtualenv
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
alias nf='neofetch --ascii ~/.config/neofetch/ascii_art'
alias bat="batcat"
alias forall='f() { for d in */; do (cd "$d" && eval "$@"); done }; f' # execute command in each child directory eg forall "ls && gst"
alias fb="fzf --preview 'batcat {} --color=always' --height=45%"
alias f='selected_dir=$(fdfind --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv | fzf --height=45%) && [ -n "$selected_dir" ] && cd "$selected_dir"'
alias rmproxy="export http_proxy= && export https_proxy= && export HTTP_PROXY= && export HTTPS_PROXY="
alias cppwd='pwd | tr -d "\n" | wl-copy'

# ---- zsh aliases ---
alias reload="source ~/.zshrc"

# ---- editor aliases ----
alias h=hx

# ---- system aliases ----
alias rescan="nmcli device wifi list --rescan yes"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"

# ---- pip variables ----
export PIP_DISABLE_PIP_VERSION_CHECK=1  # disables the annoying info about pip being upgradable

# ---- pipx variables ----
export PIPX_DEFAULT_PYTHON="$HOME/.pyenv/versions/3.11.9/bin/python"

# ---- ssh ----
export SSH_ASKPASS_REQUIRE=force
[ -f "/usr/bin/systemd-ask-password" ] && export SSH_ASKPASS=/usr/bin/systemd-ask-password

# ---- ansible ----
export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

# ---- fzf ----
export FZF_DEFAULT_OPTS='
  --color=fg:-1,fg+:#BFBDB6,bg:-1,bg+:#156772
  --color=hl:#1C9BAC,hl+:#59DCD8,info:#20AFC1,marker:#1C9BAC
  --color=prompt:#B3E5FC,spinner:#B3E5FC,pointer:#59DCD8,header:#87afaf
  --color=gutter:-1,border:#BFBDB6,label:#aeaeae,query:#d9d9d9
  --border="none" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

# ---- batcat ----
export BAT_THEME="Nord"

# ---- git delta pager ----
export DELTA_FEATURES=  # to be toggled by delta_features_toggle

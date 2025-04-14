# ---- pip variables ----
export PIP_DISABLE_PIP_VERSION_CHECK=1  # disables the annoying info about pip being upgradable

# ---- pipx variables ----
export PIPX_DEFAULT_PYTHON="/home/ginal/.pyenv/versions/3.11.9/bin/python"

# ---- nvim ----
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:/home/ginal/.local/nvim/usr/bin"

# ---- ssh ----
export SSH_ASKPASS_REQUIRE=force
export SSH_ASKPASS=/usr/bin/systemd-ask-password

# ---- ansible ----
export ANSIBLE_CALLBACK_RESULT_FORMAT=yaml

# ---- fzf ----

export FZF_DEFAULT_OPTS='
  --color=fg:-1,fg+:#BFBDB6,bg:-1,bg+:#161c23
  --color=hl:#1C9BAC,hl+:#59DCD8,info:#20AFC1,marker:#1C9BAC
  --color=prompt:#B3E5FC,spinner:#B3E5FC,pointer:#59DCD8,header:#87afaf
  --color=border:#BFBDB6,label:#aeaeae,query:#d9d9d9
  --border="none" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

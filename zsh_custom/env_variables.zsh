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

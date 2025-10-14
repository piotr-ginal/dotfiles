# ---- restore last path ----

if [ -z "$DOTFILES_INIT_FLAG" ] && [ -f "$PATH_CACHE_FILE_PATH" ]; then
  cd "$(tail -n1 "$PATH_CACHE_FILE_PATH")"
fi

export DOTFILES_INIT_FLAG=1

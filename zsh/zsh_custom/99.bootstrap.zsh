# ---- restore last path ----
if [ -f "$PATH_CACHE_FILE_PATH" ]; then
  cd $(cat "$PATH_CACHE_FILE_PATH")
fi

if [ -z "${DONT_SAVE_PATH:-}" ]; then
  chpwd() {
    printf '%s\n' "$PWD" >> "$PATH_CACHE_FILE_PATH"
  }
fi

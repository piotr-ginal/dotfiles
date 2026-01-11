# ---- restore last path ----

if [ -z "$DOTFILES_INIT_FLAG" ] && [ -f "$PATH_CACHE_FILE_PATH" ]; then
  scan_lines=${PATH_CACHE_SCAN_LINES:-50}
  file=$PATH_CACHE_FILE_PATH

  tmp=$(mktemp 2>/dev/null) || tmp="/tmp/path_cache_rev.$$"
  trap 'rm -f "$tmp"' EXIT

  if command -v tac >/dev/null 2>&1; then
    tail -n "$scan_lines" "$file" 2>/dev/null | tac 2>/dev/null >"$tmp"
  else
    tail -n "$scan_lines" "$file" 2>/dev/null | awk '{ a[NR]=$0 } END { for(i=NR;i>=1;i--) print a[i] }' >"$tmp" 2>/dev/null
  fi

  while IFS= read -r dir; do
    dir="${dir#"${dir%%[![:space:]]*}"}"
    dir="${dir%"${dir##*[![:space:]]}"}"
    [ -n "$dir" ] || continue
    [ -d "$dir" ] && { cd "$dir" 2>/dev/null || :; break; }
  done <"$tmp"
fi

export DOTFILES_INIT_FLAG=1

#!/bin/sh

MAX_COMMIT_COUNT=50

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_path>" >&2
    exit 1
fi

file="$1"

if ! git ls-files --error-unmatch -- "$file" >/dev/null 2>&1; then
  echo "$file is untracked"
  exit 0
fi

echo $file

git \
  --no-pager \
  log \
  -n $MAX_COMMIT_COUNT \
  --all \
  --graph \
  --pretty='format:%C(blue)%h %C(white) %an %ar%C(auto) %D%n%s%n' \
  -- $file

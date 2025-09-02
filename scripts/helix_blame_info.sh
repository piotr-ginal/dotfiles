#!/bin/sh

# Usage: ./blame_info.sh <file_path> <line_number>
# Prints: <short_commit_hash> <line_number> <author> <commit_message>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <file_path> <line_number>" >&2
    exit 1
fi

file="$1"
line="$2"

if ! git ls-files --error-unmatch -- "$file" >/dev/null 2>&1; then
  echo "$file is untracked"
  exit 0
fi


blame_output=$(git blame -L "$line",+1 --porcelain -- "$file")

commit=$(echo "$blame_output" | awk 'NR==1{print $1}')

git show -s --format="%h $line %an %ad%n%B" --date=iso "$commit"

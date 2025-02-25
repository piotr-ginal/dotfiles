# wsl_aliases.zsh
# wsl only aliases
# also overrides incompatible aliases from aliases.zsh to ensure they work on wsl
# filename is important - this file is loaded last

if grep -iq "microsoft" /proc/sys/kernel/osrelease; then

    # ---- cd aliases ----
    alias cdwin='cd /mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d "\r")'

    # ---- misc aliases ----
    alias cppwd='pwd | tr -d "\n" | clip.exe'

    # ---- git aliases ----
    alias opgurl='gurl | xargs explorer.exe'

fi

# overrides wayland only aliases
if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
  alias copy="tr -d '\n' | xclip -selection clipboard"
  alias cppwd="pwd | copy"
  alias lock="i3lock -c 000000"
fi

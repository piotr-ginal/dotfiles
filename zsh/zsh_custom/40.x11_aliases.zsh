# overrides wayland only aliases (and add new ones)
if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
  alias copy="sed -z '$ s/\n$//' | xclip -selection clipboard"
  alias cppwd="pwd | copy"
  alias lock="i3lock -c 000000"
  alias monitors='xrandr | grep " connected" | awk '\''{ print $1 }'\'
  unfunction cpp
  cpp() { realpath "$@" | sed -z '$ s/\n$//' | xclip -selection clipboard; }
fi

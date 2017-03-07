# 077 would be more secure, but 022 is more useful.
umask 022

# Save more history
export HISTSIZE=100000
export SAVEHIST=100000

# OS variables
[ "$(uname -s)" = "Darwin" ] && export OSX=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1

# Fix systems missing $USER
[ -z "$USER" ] && export USER="$(whoami)"

[ -s ~/.lastpwd ] && [ "$PWD" = "$HOME" ] && \
  builtin cd "$(cat ~/.lastpwd)" 2>/dev/null

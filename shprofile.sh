# 077 would be more secure, but 022 is more useful.
umask 022

# Save more history
export HISTSIZE=100000
export SAVEHIST=100000

# OS variables
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1

# Fix systems missing $USER
[ -z "$USER" ] && export USER="$(whoami)"

# Count CPUs for Make jobs
if [ $MACOS ]
then
  export CPUCOUNT=$(sysctl -n hw.ncpu)
elif [ $LINUX ]
then
  export CPUCOUNT=$(getconf _NPROCESSORS_ONLN)
else
  export CPUCOUNT="1"
fi

if [ "$CPUCOUNT" -gt 1 ]
then
  export MAKEFLAGS="-j$CPUCOUNT"
  export BUNDLE_JOBS="$CPUCOUNT"
fi

#[ -s ~/.lastpwd ] && [ "$PWD" = "$HOME" ] && \
#  builtin cd "$(cat ~/.lastpwd)" 2>/dev/null

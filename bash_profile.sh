#!/bin/bash
# load shared shell configuration
source ~/.shprofile

# check if this is a login and/or interactive shell
[ "$0" = "-bash" ] && export LOGIN_BASH="1"
echo "$-" | grep -q "i" && export INTERACTIVE_BASH="1"

# run bashrc if this is a login, interactive shell
if [ -n "$LOGIN_BASH" ] && [ -n "$INTERACTIVE_BASH" ]
then
  source ~/.bashrc
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

# Save multiline commands
shopt -s cmdhist

# Correct minor directory changing spelling mistakes
shopt -s cdspell

if [ "$MACOS" ]; then
  # Bash completion
  [ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
  [ -f "$HOMEBREW_PREFIX/etc/bash_completion" ] && source "$HOMEBREW_PREFIX/etc/bash_completion" >/dev/null

  # Git completion
  if [ -f "$(brew --prefix)"/etc/bash_completion.d/git-completion.bash ] ; then
    . "$(brew --prefix)"/etc/bash_completion.d/git-completion.bash
  elif [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
    . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
  fi

fi

# only set key bindings on interactive shell
if [ -n "$INTERACTIVE_BASH" ]
then
  # fix delete key on OSX
  [ "$MACOS" ] && bind '"\e[3~" delete-char'

  # alternate mappings for Ctrl-U/V to search the history
  bind '"^u" history-search-backward'
  bind '"^v" history-search-forward'
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

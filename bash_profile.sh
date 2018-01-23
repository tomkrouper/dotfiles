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

# Setup screencapture
if [ "$MACOS" ]; then
  if [ ! -d "$HOME/Desktop/Screenshots" ]; then
    mkdir -p "$HOME/Desktop/Screenshots"
  fi
  screencapture_location=$(defaults read com.apple.screencapture location 2> /dev/null)
  if [ $? -eq 1 ]; then
    defaults write com.apple.screencapture location "$HOME/Desktop/Screenshots"
  elif [ $screencapture_location != "$HOME/Desktop/Screenshots" ]; then
    defaults write com.apple.screencapture location "$HOME/Desktop/Screenshots"
  fi
fi

# Set HOST for ZSH compatibility
export HOST=$HOSTNAME

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
if [ -f $(brew --prefix)/etc/bash_completion.d/git-completion.bash ] ; then
  . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
elif [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
  . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fi

# Git prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS=1
if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
  . $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
elif [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh ]; then
  . /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
fi

# Colorful prompt
if [ "$USER" = "root" ]
then
  PS1='\[\033[01;35m\]\h\[\033[01;34m\] \W$(__git_ps1 " (%s)")#\[\033[00m\] '
elif [ -n "${SSH_CONNECTION}" ]
then
  PS1='\[\033[01;36m\]\h\[\033[01;34m\] \W$(__git_ps1 " (%s)")$\[\033[00m\] '
else
  PS1='\[\033[01;32m\]\h\[\033[01;34m\] \W$(__git_ps1 " (%s)")$\[\033[00m\] '
fi
# End MACOS
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

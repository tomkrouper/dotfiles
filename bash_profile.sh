# load shared shell configuration
source ~/.shprofile

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

# Bash completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
[ -f "$BREW_PREFIX/etc/bash_completion" ] && source "$BREW_PREFIX/etc/bash_completion" >/dev/null

# fix delete key on OSX
[ "$OSX" ] && bind '"\e[3~" delete-char'

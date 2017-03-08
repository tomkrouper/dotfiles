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

# git completion & prompt
[ -f /usr/local/etc/bash_completion.d/git-completion.bash ] && source /usr/local/etc/bash_completion.d/git-completion.bash
[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] && source /usr/local/etc/bash_completion.d/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

eval "$(rbenv init -)"
eval "$(nodenv init -)"

ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh-auth-sock.$HOSTNAME"

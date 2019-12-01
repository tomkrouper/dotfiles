#!/bin/bash
# check if this is a login shell
[ "$0" = "-bash" ] && export LOGIN_BASH="1"

# run bash_profile if this is not a login shell
[ -z "$LOGIN_BASH" ] && source ~/.bash_profile

# load shared shell configuration
source ~/.shrc

# History
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND='history -a'
export HISTIGNORE="&:ls:[bf]g:exit"

export VAULT_URL="none"

[[ $- = *i* ]] && source ~/Documents/GitHub/liquidprompt/liquidprompt

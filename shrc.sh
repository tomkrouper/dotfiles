#!/bin/bash
# shellcheck disable=SC2155

# Colourful manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export LESS_TERMEND=$'\E[0m' # Set to avoid `env` output from changing console colour

# Setup PATH

# Remove from anywhere in PATH
remove_from_path() {
  [[ -d "$1" ]] || return
  PATHSUB=":${PATH}:"
  PATHSUB=${PATHSUB//:$1:/:}
  PATHSUB=${PATHSUB#:}
  PATHSUB=${PATHSUB%:}
  export PATH="${PATHSUB}"
}

# Add to the start of PATH if it exists
add_to_path_start() {
  [[ -d "$1" ]] || return
  remove_from_path "$1"
  export PATH="$1:${PATH}"
}

# Add to the end of PATH if it exists
add_to_path_end() {
  [[ -d "$1" ]] || return
  remove_from_path "$1"
  export PATH="${PATH}:$1"
}

# Add to PATH even if it doesn't exist
force_add_to_path_start() {
  remove_from_path "$1"
  export PATH="$1:${PATH}"
}

quiet_which() {
  command -v "$1" >/dev/null
}

add_to_path_start "/opt/homebrew/bin"
add_to_path_start "/usr/local/bin"
add_to_path_end "${HOME}/.dotfiles/bin"

export GOPATH="${HOME}/.gopath" # Setup Go development
add_to_path_end "${GOPATH}/bin"

# Aliases
alias cp="cp -rv"
alias df="df -H"
alias du="du -sh"
alias less="less -FXR"
alias ls="ls -FA"
alias ll="ls -l"
alias mkdir="mkdir -vp"
alias mv="mv -v"
alias rm="rm -v"
alias rsync="rsync --partial --progress --human-readable --compress"

# Command-specific stuff
if quiet_which brew; then
  eval "$(brew shellenv)"

  #export HOMEBREW_DEVELOPER=1
  #export HOMEBREW_BOOTSNAP=1
  export HOMEBREW_BUNDLE_INSTALL_CLEANUP=1
  #export HOMEBREW_BUNDLE_DUMP_DESCRIBE=1
  #export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_AUTOREMOVE=1
  export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=1
  export HOMEBREW_CLEANUP_MAX_AGE_DAYS=5
  #export HOMEBREW_SORBET_RUNTIME=1
  #export HOMEBREW_RUBY3=1
fi

# shellcheck disable=SC2016
export GIT_PAGER='less -+$LESS -RX'

if quiet_which bat; then
  alias cat="bat"
  export HOMEBREW_BAT=1
fi

export CLICOLOR=1 # Configure environment
export GREP_OPTIONS="--color=auto"

add_to_path_end "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# output what's listening on the supplied port
on-port() {
  sudo lsof -nP -i4TCP:"$1"
}

export EDITOR="vim"

# Move files to the Trash folder
trash() {
  mv "$@" "${HOME}/.Trash/"
}

# GitHub API shortcut
github-api-curl() {
  curl -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/$1" | jq .
}

# Clear entire screen buffer
clearer() {
  tput reset
}
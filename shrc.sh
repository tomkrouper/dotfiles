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

# Set to avoid `env` output from changing console colour
export LESS_TERMEND=$'\E[0m'

# Print field by number
field() {
  ruby -ane "puts \$F[$1]"
}

# Setup paths
remove_from_path() {
  [ -d "$1" ] || return
  # Doesn't work for first item in the PATH but I don't care.
  export PATH=${PATH//:$1/}
}

add_to_path_start() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

add_to_path_end() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$PATH:$1"
}

force_add_to_path_start() {
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

quiet_which() {
# shellcheck disable=SC2230
  which "$1" &>/dev/null
}

add_to_path_end "/sbin"
add_to_path_start "/usr/local/bin"
add_to_path_start "/usr/local/sbin"
add_to_path_start "$HOME/Homebrew/bin"
add_to_path_start "$HOME/Homebrew/sbin"

export GOPATH="$HOME/go"
add_to_path_end "$GOPATH/bin"
export GOROOT=/usr/local/opt/go/libexec
add_to_path_start "/usr/local/opt/go/libexec/bin"
export GODEBUG=netdns=go

add_to_path_end "$(brew --prefix mysql@5.7)/bin"
add_to_path_start "$HOME/bin"

# Run rbenv if it exists
quiet_which rbenv && add_to_path_start "$(rbenv root)/shims"

# Aliases
alias mkdir="mkdir -vp"
alias df="df -H"
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -irv"
alias du="du -sh"
alias make="nice make"
alias less="less -FSXr"
alias rsync="rsync --partial --progress --human-readable --compress"
alias sha256="shasum -a 256"

# Platform-specific stuff
if quiet_which brew
then
  export HOMEBREW_PREFIX="$(brew --prefix)"
  export HOMEBREW_REPOSITORY="$(brew --repo)"
  export HOMEBREW_AUTO_UPDATE_SECS=3600
  export HOMEBREW_BINTRAY_USER="$(git config bintray.username)"

  alias hbc='cd $HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core'

  # Output whether the dependencies for a Homebrew package are bottled.
  brew_bottled_deps() {
    for DEP in "$@"; do
      echo "$DEP deps:"
      brew deps "$DEP" | xargs brew info | grep stable
      [ "$#" -ne 1 ] && echo
    done
  }

  # Output the most popular unbottled Homebrew packages
  brew_popular_unbottled() {
    brew deps --all |
      awk '{ gsub(":? ", "\n") } 1' |
      sort |
      uniq -c |
      sort |
      tail -n 500 |
      awk '{print $2}' |
      xargs brew info |
      grep stable |
      grep -v bottled
  }
fi

if quiet_which exa; then
  alias ls="exa -Fg"
  alias ll="exa -Fgl --time-style=long-iso --git"
else
  alias ls="ls -F"
  alias ll="ls -l"
fi

# Platform-specific stuff
if [ "$MACOS" ]
then
  export GREP_OPTIONS="--color=auto"
  export LSCOLORS=cxFxcxdxBxegedabagacHe
  export CLICOLOR=1

  add_to_path_end "$HOMEBREW_PREFIX/opt/git/share/git-core/contrib/diff-highlight"
  if quiet_which diff-highlight
  then
    # shellcheck disable=SC2016
    export GIT_PAGER='diff-highlight | less -+$LESS -FRX'
  else
    # shellcheck disable=SC2016
    export GIT_PAGER='less -+$LESS -FRX'
  fi
  add_to_path_end /Applications/Xcode.app/Contents/Developer/usr/bin
  add_to_path_end /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

  alias locate="mdfind -name"
  alias cpwd="pwd | tr -d '\\n' | pbcopy"

elif [ "$LINUX" ]
then
  quiet_which keychain && eval "$(keychain -q --eval --agents ssh id_rsa)"

  alias su="/bin/su -"
fi

if quiet_which vim
then
  export EDITOR="vim"
elif quiet_which vi
then
  export EDITOR="vi"
fi

# Save directory changes
cd() {
  builtin cd "$@" || return
  pwd > "$HOME/.lastpwd"
  ls
}

cat() {
  /bin/cat "$@" | /usr/local/bin/sed -e "s/password=.*/password=hunter2/" || return
}

# Pretty-print JSON files
json() {
  [ -n "$1" ] || return
  jsonlint "$1" | jq .
}

# Pretty-print Homebrew install receipts
receipt() {
  [ -n "$1" ] || return
  json "$HOMEBREW_PREFIX/opt/$1/INSTALL_RECEIPT.json"
}

# Move files to the Trash folder
trash() {
  mv "$@" "$HOME/.Trash/"
}

existing-pr() {
  local branch
  if branch="$(git rev-parse --symbolic-full-name '@{upstream}' 2>/dev/null)"; then
    branch="${branch#refs/remotes/}"
    branch="${branch#*/}"
  else
    branch="$(git rev-parse --symbolic-full-name HEAD)"
    branch="${branch#refs/heads/}"
  fi

# shellcheck disable=SC2016
  hub api -t graphql -fbranch="$branch" -fquery='
    query($branch: String!) {
      repository(owner: "{owner}", name: "{repo}") {
        pullRequests(headRefName: $branch, states: OPEN, first: 10) {
          edges {
            node {
              url
              repository {
                owner {
                  login
                }
              }
              headRepository {
                owner {
                  login
                }
              }
            }
          }
        }
      }
    }
  ' | group_edges 3 | while read -r url base_owner head_owner; do
    [ "$base_owner" != "$head_owner" ] || printf '%s\n' "$url"
  done | head -1
}

group_edges() {
  grep -F '[' | cut -f2 | xargs -L"${1?}"
}

# Look in ./bin but do it last to avoid weird `which` results.
force_add_to_path_start "bin"

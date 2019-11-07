# load shared shell configuration
source ~/.shprofile

# Enable completions
autoload -U compinit && compinit

if which brew &>/dev/null
then
  [ -w "$HOMEBREW_PREFIX/bin/brew" ] && \
    [ ! -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew" ] && \
    mkdir -p "$HOMEBREW_PREFIX/share/zsh/site-functions" &>/dev/null && \
    ln -s "$HOMEBREW_PREFIX/Library/Contributions/brew_zsh_completion.zsh" \
          "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew"
  export FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

# Enable regex moving
autoload -U zmv

# Style ZSH output
zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case insensitive globbing
setopt no_case_glob

# Expand parameters, commands and aritmatic in prompts
setopt prompt_subst

# Colorful prompt with Git and Subversion branch
autoload -U colors && colors

git_branch() {
  GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  [ -n "$GIT_BRANCH" ] && echo "($GIT_BRANCH) "
}

svn_branch() {
  [ -d .svn ] || return
  SVN_INFO=$(svn info 2>/dev/null) || return
  SVN_BRANCH=$(echo "$SVN_INFO" | grep URL: | grep -oe '\(trunk\|branches/[^/]\+\|tags/[^/]\+\)')
  [ -n "$SVN_BRANCH" ] || return
  # Display tags intentionally so we don't write to them by mistake
  echo "(${SVN_BRANCH#branches/}) "
}

# more macOS/Bash-like word jumps
export WORDCHARS=""

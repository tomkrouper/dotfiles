# shellcheck disable=SC2148

if which brew &>/dev/null; then
  eval "$(brew shellenv)"
fi

umask 022 # 077 would be more secure, but 022 is more useful.
export HISTSIZE="100000" # Save more history
export SAVEHIST="100000" # Save more history

# shellcheck disable=SC2155
[ -z "$USER" ] && export USER="$(whoami)" # Fix systems missing $USER

# Count CPUs for Make jobs
# shellcheck disable=SC2155
export CPUCOUNT="$(sysctl -n hw.ncpu)"

if [ "$CPUCOUNT" -gt 1 ]; then
  export MAKEFLAGS="-j$CPUCOUNT"
  export BUNDLE_JOBS="$CPUCOUNT"
fi

autoload -U compinit && compinit -u # Enable completions and allow insecure loading

if [ -n "$HOMEBREW_PREFIX" ]; then
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u' # Style ZSH output
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b' # Style ZSH output
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
setopt no_case_glob # Case insensitive globbing
setopt prompt_subst # Expand parameters, commands and arithmetic in prompts
autoload -U colors && colors # Colorful prompt with Git and Subversion branch

git_branch() {
  GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  [ -n "$GIT_BRANCH" ] && echo "($GIT_BRANCH) "
}

# more macOS/Bash-like word jumps
export WORDCHARS=""

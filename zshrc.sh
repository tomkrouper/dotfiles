# shellcheck disable=SC2148,SC1090

# powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# zsh auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

HIST_STAMPS="yyyy-mm-dd"

plugins=(git fzf)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zprofile # always source zprofile regardless of whether this is/isn't a login shell
source ~/.shrc # load shared shell configuration
export HISTFILE=~/.zsh_history # History file
setopt hist_find_no_dups # Don't show duplicate history entires
setopt hist_reduce_blanks # Remove unnecessary blanks from history
setopt share_history # Share history between instances
setopt no_hup # Don't hang up background jobs
setopt correct # autocorrect command and parameter spelling
setopt correctall
# bindkey -e # use emacs bindings even with vim as EDITOR
bindkey '\e[3~' delete-char # fix delete key on macOS

bindkey "^u" history-beginning-search-backward # alternate mappings for Ctrl-U to search the history
bindkey "^v" history-beginning-search-forward # alternate mappings for Ctrl-V to search the history

ZSH_AUTOSUGGESTIONS="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" # enable autosuggestions
[ -f "$ZSH_AUTOSUGGESTIONS" ] && source "$ZSH_AUTOSUGGESTIONS"

which direnv &>/dev/null && eval "$(direnv hook zsh)" # enable direnv (if installed)

# to avoid non-zero exit code
true

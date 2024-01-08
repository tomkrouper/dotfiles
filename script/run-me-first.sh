#!/bin/bash

git clone https://github.com/tomkrouper/dotfiles.git "${HOME}"/.dotfiles
cd "${HOME}"/.dotfiles/script || exit
./setup
# Never directly install anything from the internet 😬
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/usr/local/bin/brew shellenv)"
brew bundle install --global
# Didn't I say something above about this? ಠ_ಠ
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
/usr/local/opt/fzf/install --all

# Use VIMs built in packages
git clone https://github.com/vim-airline/vim-airline ~/.vim/pack/plugins/start/vim-airline
vim -u NONE -c "helptags $HOME/.vim/pack/plugins/start/vim-airline/doc" -c q
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/pack/plugins/start/vim-airline-themes
vim -u NONE -c "helptags $HOME/.vim/pack/plugins/start/vim-airline-themes/doc" -c q
git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.vim/pack/plugins/start/ale
vim -u NONE -c "helptags $HOME/.vim/pack/plugins/start/ale/doc" -c q
git clone https://github.com/altercation/vim-colors-solarized.git ~/.vim/pack/plugins/start/vim-colors-solarized
vim -u NONE -c "helptags $HOME/.vim/pack/plugins/start/vim-colors-solarized/doc" -c q

./extract-onepassword-secrets

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
mkdir -p ~/.vim/{autoload,backup,colors,plugged}
curl -o "$HOME"/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
./extract-onepassword-secrets

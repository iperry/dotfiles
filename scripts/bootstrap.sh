#!/usr/bin/env bash

DOTFILES_DIR=$HOME/dotfiles

link_dotfile () {
  src=$DOTFILES_DIR/$1
  target=$2
  ln -sf $src $target
}

echo $DOTFILES_DIR

# git
link_dotfile gitconfig $HOME/.gitconfig

# zsh
link_dotfile zshrc $HOME/.zshrc
link_dotfile zsh $HOME/.zsh

# # neovim
echo "installing vim-plug"
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

link_dotfile vimrc $HOME/.config/nvim/init.vim

# scripts
mkdir -p ~/bin

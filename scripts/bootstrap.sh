#!/usr/bin/env bash
DOTFILES_DIR=$HOME/dotfiles
link_dotfile () {
  src=$DOTFILES_DIR/$1
  target=$2
  d="$(dirname $2)"
  set -x
  mkdir -p $d
  ln -sf $src $target
  set +x
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

link_dotfile xinitrc $HOME/.xinitrc
mkdir -p ~/.xmonad/
link_dotfile xmobarrc $HOME/.xmobarrc
link_dotfile xmonad.hs $HOME/.xmonad/xmonad.hs

# tmux
link_dotfile tmux.conf $HOME/.tmux.conf

# kitty
link_dotfile kitty.conf $HOME/.config/kitty/kitty.conf

# ssh-agent
link_dotfile ssh-agent.service $HOME/.config/systemd/user/ssh-agent.service

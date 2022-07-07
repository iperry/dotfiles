#!/usr/bin/env bash

add-apt-repository ppa:neovim-ppa/unstable
apt-get update
apt-get install wget curl neovim python-dev python-pip python3-dev python3-pip xclip

pip install neovim

apt-get install zsh

# development stuff
apt-get install \
  git-core      \
  clang         \
  clangd        \
  clang-format  \
  ccache        \
  cmake         \
  ripgrep

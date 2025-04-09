#!/usr/bin/env bash

add-apt-repository ppa:neovim-ppa/stable
apt-get update
apt-get install wget curl neovim python3-pip python3-dev python3-pip

pip3 install neovim

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

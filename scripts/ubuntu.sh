#!/usr/bin/env bash

add-apt-repository ppa:neovim-ppa/unstable
apt-get update
apt-get install wget curl neovim python-dev python-pip python3-dev python3-pip xclip

pip install neovim

# fonts:
wget http://mirrors.kernel.org/ubuntu/pool/universe/f/fonts-hack/fonts-hack-ttf_2.018-1_all.deb -O /tmp/hack.deb
dpkg -i /tmp/hack.deb

apt-get install zsh

# development stuff
apt-get install git-core clang ccache

apt-get install cmake

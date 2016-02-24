#!/usr/bin/env bash

add-apt-repository ppa:neovim-ppa/unstable
apt-get update
apt-get install wget curl neovim python-dev python-pip python3-dev python3-pip xclip

pip install neovim

# fonts:
mkdir -p ~/.fonts
wget https://github.com/chrissimpkins/Hack/releases/download/v2.019/Hack-v2_019-ttf.zip -O /tmp/hack.zip
unzip /tmp/hack.zip -d ~/.fonts
fc-cache -fv

apt-get install zsh

# development stuff
apt-get install git-core clang ccache

apt-get install cmake

add-apt-repository ppa:h-realh/roxterm
apt-get install roxterm

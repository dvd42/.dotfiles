#!/bin/bash

#Inspired on https://github.com/prlz77/nvim

# Dependencies
sudo apt-get -y install python3-dev python3-pip python3-setuptools curl xclip silversearcher-ag ranger fd-find
sudo apt-get -y install build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev tk-dev

ln -s $(which fdfind) ~/.local/bin/fd

# install neovim
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt-get -y install neovim

# Common configuration
./common_install.sh


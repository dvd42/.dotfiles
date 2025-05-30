#!/bin/bash

#Inspired on https://github.com/prlz77/nvim

# Dependencies
sudo apt-get -y install python3-dev python3-pip python3-setuptools curl xclip silversearcher-ag fd-find
sudo apt-get -y install build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev tk-dev

ln -s $(which fdfind) ~/.local/bin/fd

# install neovim
sudo apt-get -y install software-properties-common
sudo apt-get autoremove
sudo apt update
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo ln -sf ~/.dotfiles/nvim/nvim.appimage /usr/bin/nvim


sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --auto vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --auto vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --auto editor

# Common configuration
#./common_install.sh


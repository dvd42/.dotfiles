#!/bin/bash

#Taken from https://github.com/prlz77/nvim

# Update and install
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get -y install neovim
# Dependencies
sudo apt-get -y install python-dev python-pip python3-dev python3-pip curl xclip graphviz
# Set as the default editor
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor
pip3 install --user neovim
# Common configuration
./common_install.sh


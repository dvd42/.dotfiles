#!/bin/bash

#Inspired on https://github.com/prlz77/nvim

# Update and install
sudo apt-get update
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get -y install neovim
# Dependencies
sudo apt-get -y install python-dev python3-dev python3-pip python3-setuptools curl xclip silversearcher-ag  

# Set as the default editor
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --auto vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --auto vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --auto editor
# Common configuration
./common_install.sh


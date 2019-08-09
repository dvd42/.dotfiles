#! /bin/bash

# Terminal music player
sudo apt-get -y install cmus

# Hangouts terminal client
sudo pip3 install hangups

cd ~/.config/env_setup/
# Tmux installation
sh tmux/install.sh

# Nvim installation
cd nvim
sh ubuntu_install.sh
cd ~/.config
ln -s -f env_setup/nvim 

# Zsh shell installation
cd ~/.config/env_setup 
sh zsh/install.sh

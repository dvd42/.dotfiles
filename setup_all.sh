#! /bin/bash

# Terminal music player
sudo apt-get -y install cmus

sudo apt-get -y install git

cd ~/.config/env_setup/
# Tmux installation
sh tmux/install.sh

# Nvim installation
cd nvim
sh ubuntu_install.sh

# Zsh shell installation
cd ~/.config/env_setup 
sh zsh/install.sh

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global --add difftool.prompt false 


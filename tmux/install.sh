#! /bin/bash
sudo apt-get -y install wget tar libevent-dev libncurses-dev tmux xclip

cd
ln -s -f .dotfiles/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/.dotfiles/tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tmux-continuum.git ~/.dotfiles/tmux/plugins/tmux-continuum
git clone https://github.com/pwittchen/tmux-plugin-ip.git ~/.dotfiles/tmux/plugins/tmux-plugin-ip

source ~/.bashrc

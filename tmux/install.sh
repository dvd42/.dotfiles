#! /bin/bash
sudo apt-get -y install wget tar libevent-dev libncurses-dev xclip

wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
tar -zxf tmux-*.tar.gz
cd tmux-*/
./configure
make && sudo make install

cd
ln -s -f .dotfiles/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/.dotfiles/tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tmux-continuum.git ~/.dotfiles/tmux/plugins/tmux-continuum
git clone https://github.com/pwittchen/tmux-plugin-ip.git ~/.dotfiles/tmux/plugins/tmux-plugin-ip

source ~/.bashrc

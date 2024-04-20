#! /bin/bash
sudo brew update && sudo
brew install wget tar libevent libncurses

# Download and build tmux from source
wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
tar -zxf tmux-*.tar.gz
cd tmux-*/
./configure
make && sudo
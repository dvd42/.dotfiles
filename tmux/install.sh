#! /bin/bash
sudo apt-get install tmux
sudo apt-get install xclip
cd 
ln -s -f .config/env_setup/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/arcticicestudio/nord-tmux ~/.config/env_setup/tmux/themes/nord-tmux

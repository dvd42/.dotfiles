#! /bin/bash
sudo apt-get -y install tmux
sudo apt-get -y install xclip
sudo apt-get -y install acpi

cd
ln -s -f .config/env_setup/tmux/tmux.conf ~/.tmux.conf
git clone git@github.com:tmux-plugins/tmux-resurrect.git ~/.config/env_setup/tmux/plugins/tmux-resurrect
git clone git@github.com:tmux-plugins/tmux-continuum.git ~/.config/env_setup/tmux/plugins/tmux-continuum
git clone git@github.com:pwittchen/tmux-plugin-ip.git ~/.config/env_setup/tmux/plugins/tmux-plugin-ip

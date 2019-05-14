#! /bin/bash
sudo apt-get install tmux
sudo apt-get install xclip
sudo apt-get install acpi
cd 
ln -s -f .config/env_setup/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/arcticicestudio/nord-tmux ~/.config/env_setup/tmux/themes/nord-tmux
git clone https://github.com/tmux-plugins/tmux-battery ~/.config/env_setup/tmux/plugins/tmux-battery
git clone https://github.com/jimeh/tmux-themepack.git ~/.config/env_setup/tmux/plugins/tmux-themepack

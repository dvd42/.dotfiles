sh tmux/install.sh
sh zsh/install.sh
sh ../nvim/ubuntu_install.sh
pip3 install --user -r nvim/requirements.txt
cd ~/.config
ln -s -f env_setup/nvim nvim 

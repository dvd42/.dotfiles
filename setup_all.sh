#! /bin/bash

sudo apt-get install --no-install-recommends -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Zsh shell installation
sh zsh/install.sh

# Tmux installation
sh tmux/install.sh

# Nvim installation
cd ~/.dotfiles/nvim
sh ubuntu_install.sh

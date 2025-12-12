#!/bin/bash

#Inspired on https://github.com/prlz77/nvim

#backup dirs
mkdir undodir
mkdir backup

# set up fd
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
export PATH="$HOME/.local/bin/:$PATH"

ln -s -f ~/.dotfiles/nvim ~/.config/nvim

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global --add difftool.prompt false

# install pyenv
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
source ~/.bashrc

exec $SHELL
chsh -s $(which zsh)

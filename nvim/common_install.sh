#!/bin/bash 

#Inspired on https://github.com/prlz77/nvim

#backup dirs
mkdir undodir
mkdir backup

# set up ranger
mkdir -p ~/.config/ranger
touch ~/.config/ranger/rc.conf

# set up fd
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
export PATH="$HOME/.local/bin/:$PATH"

echo "set preview_images=true\nset preview_images_method=ueberzug" >> ~/.config/ranger/rc.conf

ln -s -f ~/.dotfiles/nvim ~/.config/nvim

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global --add difftool.prompt false 

# vim-plug
curl -fLo ./autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

touch trusted_ips.txt

# install pyenv
git clone https://gist.github.com/capsulecorplab/2d1998522c36f84a070380e766b0423a pyenv_installer/

curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
source ~/.bashrc

exec $SHELL

#!/bin/bash 

#Inspired on https://github.com/prlz77/nvim

#backup dirs
mkdir undodir
mkdir backup

# set up ranger
mkdir ~/.config/ranger
touch ~/.config/ranger/rc.conf
echo "set preview_images=true\nset preview_images_method=ueberzug" >> ~/.config/ranger/rc.conf

ln -s -f ~/.dotfiles/nvim ~/.config/nvim

git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global --add difftool.prompt false 

# vim-plug
curl -fLo ./autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

mkdir -p ~/.local/share/fonts
curl -fLo "$HOME/.local/share/fonts/Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
touch trusted_ips.txt

# install pyenv
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
echo export PATH="$HOME/.pyenv/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin/:$PATH"' >> ~/.bashrc
echo eval "$(pyenv init --path)" >> ~/.bashrc
source ~/.bashrc
pyenv install 3.8.0
bash --rcfile <(echo '. ~/.bashrc; pyenv virtualenv 3.8.0 neovim; pyenv activate neovim; pip3 install neovim pynvim jedi autopep8; pyenv deactivate; exit')
nvim --headless +UpdateRemotePlugins +qa
exec $SHELL

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

touch trusted_ips.txt
source ~/.bashrc

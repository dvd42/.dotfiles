#Taken from https://github.com/prlz77/nvim
#backup dirs
mkdir undodir
mkdir backup

# vim-plug
curl -fLo ./autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install pyenv
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
pyenv install 3.6.8
pyenv virtualenv 3.6.8 neovim3
pyenv activate neovim3
pyenv deactivate 
pip3 install neovim

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

pip3 install --upgrade --user --ignore-installed -r requirements.txt
touch trusted_ips.txt

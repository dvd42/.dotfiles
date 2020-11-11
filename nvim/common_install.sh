#Taken from https://github.com/prlz77/nvim
#backup dirs
mkdir undodir
mkdir backup

# set up ranger
git clone git@github.com:ranger/ranger.git
cd ranger
sudo make install
cd ..
mkdir ~/.config/ranger
touch ~/.config/ranger/rc.conf
echo "set preview_images=true\nset preview_images_method=ueberzug" >> ~/.config/ranger/rc.conf

ln -s -f ~/.config/env_setup/nvim ~/.config/nvim

# vim-plug
curl -fLo ./autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install pyenv
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
pyenv install 3.8.0
pyenv virtualenv 3.8.0 neovim
pyenv activate neovim3
pip3 install neovim pynvim jedi
pyenv deactivate 

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

pip3 install --upgrade --user --ignore-installed -r requirements.txt
touch trusted_ips.txt

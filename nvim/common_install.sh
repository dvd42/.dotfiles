#Taken from https://github.com/prlz77/nvim
#backup dirs
mkdir undodir
mkdir backup

# set up ranger
git clone https://github.com/ranger/ranger.git
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
echo "export PATH=\"$HOME/.pyenv/bin:$PATH\"" >> ~/.bashrc
source ~/.bashrc
echo eval "$(pyenv init -)" >> ~/.bashrc
echo eval "$(pyenv virtualenv-init -)" >> ~/.bashrc
source ~/.bashrc
pyenv install 3.8.0
pyenv virtualenv 3.8.0 neovim
pyenv activate neovim
pip3 install neovim pynvim jedi autopep8
pyenv deactivate

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

mkdir -p ~/.local/share/fonts
curl -fLo "$HOME/.local/share/fonts/Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
touch trusted_ips.txt

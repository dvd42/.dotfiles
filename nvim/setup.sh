echo export PYENV_ROOT="$HOME/.pyenv" >> ~/.profile
source ~/.profile
echo export PATH="$PYENV_ROOT/bin/:$PATH" >> ~/.profile
source ~/.profile
echo eval "$(pyenv init --path)" >> ~/.profile
source ~/.profile
eval "$(pyenv init -)" >> ~/.bashrc
eval "$(pyenv virtualenv-init -)" >> ~/.bashrc
echo eval "$(pyenv init -)" >> ~/.bashrc
echo eval "$(pyenv virtualenv-init -)" >> ~/.bashrc
source ~/.bashrc
pyenv install 3.8.0
pyenv virtualenv 3.8.0 neovim
pyenv activate neovim
pip3 install neovim pynvim jedi autopep8
pyenv deactivate

# bash --rcfile <(echo '. ~/.bashrc; pyenv virtualenv 3.8.0 neovim; pyenv activate neovim; pip3 install neovim pynvim jedi autopep8; pyenv deactivate; exit')
sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa
nvim --headless +CocInstall coc-json coc-tsserver coc-jedi

source ~/.profile
source ~/.zshrc

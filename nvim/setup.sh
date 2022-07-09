echo export PYENV_ROOT="$HOME/.pyenv" >> ~/.profile
echo export PATH="$PYENV_ROOT/bin/:$PATH" >> ~/.profile
source ~/.profile
echo eval "$(pyenv init --path)" >> ~/.profile
source ~/.profile
eval "$(pyenv init -)" >> ~/.bashrc
eval "$(pyenv virtualenv-init -)" >> ~/.bashrc
source ~/.bashrc
pyenv install 3.8.0
pyenv virtualenv 3.8.0 neovim
pyenv activate neovim
pip3 install neovim pynvim jedi autopep8
pyenv deactivate

# bash --rcfile <(echo '. ~/.bashrc; pyenv virtualenv 3.8.0 neovim; pyenv activate neovim; pip3 install neovim pynvim jedi autopep8; pyenv deactivate; exit')
nvim --headless +UpdateRemotePlugins +qa

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

source ~/.bashrc

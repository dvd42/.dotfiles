pyenv activate neovim
pip3 install neovim pynvim jedi autopep8
pyenv deactivate

# bash --rcfile <(echo '. ~/.bashrc; pyenv virtualenv 3.8.0 neovim; pyenv activate neovim; pip3 install neovim pynvim jedi autopep8; pyenv deactivate; exit')
nvim --headless +UpdateRemotePlugins +qa

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

source ~/.bashrc

sudo apt-get update
sudo apg-get install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)

cd 
ln -s .config/env_setup/zsh/zshrc .zshrc




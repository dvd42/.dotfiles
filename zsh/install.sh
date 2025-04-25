#! /bin/bash
sudo apt-get -y update
sudo apt-get -y install zsh
sudo apt-get -y install curl
sudo apt-get -y install fzf
sudo apt-get -y install bat
sudo apt-get -y install fd-find

CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# codeselect
curl -sSL https://raw.githubusercontent.com/maynetee/codeselect/main/install.sh | bash

cd
ln -s -f .dotfiles/zsh/zshrc .zshrc
chsh -s `which zsh`

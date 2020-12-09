#! /bin/bash

# My prefered font
sudo apt install -y fonts-firacode

sudo apt-get -y update
sudo apt-get -y install zsh
sudo apt-get -y install curl

CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cd
ln -s -f .config/env_setup/zsh/zshrc .zshrc
mv .oh-my-zsh .config/env_setup/zsh/
cd ~/.config/env_setup/zsh/.oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd ~/.config/env_setup/zsh/
cp myagnoster.zsh-theme ~/.config/env_setup/zsh/.oh-my-zsh/themes/
chsh -s `which zsh`

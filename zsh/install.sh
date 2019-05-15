#! /bin/bash
sudo apt-get update
sudo apt-get -y install zsh

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/\s*env\s\s*zsh\s*/d')" \

cd 
ln -s -f .config/env_setup/zsh/zshrc .zshrc
mv .oh-my-zsh .config/env_setup/zsh/oh-my-zsh
cd ~/.config/env_setup/zsh/oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions  
git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd ~/.config/env_setup/zsh/
cp agnoster.zsh-theme ~/.config/env_setup/zsh/oh-my-zsh/themes/
cd
/usr/bin/gnome-session-quit --no-prompt

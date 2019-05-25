#! /bin/bash
sudo apt-get -y update
sudo apt-get -y install zsh
sudo apt -y install gnome-session-bin

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed -e 's/^\s*chsh -s/sudo chsh -s/g' -e 's/^\s*env\szsh.*$/#/g')"

cd
ln -s -f .config/env_setup/zsh/zshrc .zshrc
mv .oh-my-zsh .config/env_setup/zsh/oh-my-zsh
cd ~/.config/env_setup/zsh/oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd ~/.config/env_setup/zsh/
cp agnoster.zsh-theme ~/.config/env_setup/zsh/oh-my-zsh/themes/
chsh -s `which zsh`
gnome-session-quit

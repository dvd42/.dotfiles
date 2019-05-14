sudo apt-get update
sudo apg-get install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)

cd 
ln -s .config/env_setup/zsh/zshrc .zshr
cd ~/.config/env_setup/zsh/oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions  
git clone https://github.com/zsh-users/zsh-syntax-highlighting
cd ~/.config/env_setup/zsh/
cp agnoster.zsh-theme ~/.config/env_setup/zsh/oh-my-zsh/themes/

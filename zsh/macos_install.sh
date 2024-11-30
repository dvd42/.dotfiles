#! /bin/bash
CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cd
ln -s -f .dotfiles/zsh/zshrc .zshrc

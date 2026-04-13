#! /bin/bash

# tmux
brew install tmux

# TPM (tmux plugin manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# Install plugins non-interactively
~/.tmux/plugins/tpm/bin/install_plugins || true

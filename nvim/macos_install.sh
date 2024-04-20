#! /bin/bash
sudo brew update && sudo
brew install neovim python3 xml libtool libxlm caret libxxl bat

# Set up Neovim with all necessary plugins and configurations
curl -L "https://raw.github.com/neovim/neovim/master/install.sh" | sh
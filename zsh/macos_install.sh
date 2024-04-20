#! /bin/bash
sudo brew update && sudo
brew install zsh curl zlibre libedit
sudo brew install gnu make gnu wget

# Download and install oh-my-zsh install script from Robby Russell's github repo 
# Note: These commands work both on macOS and Linux. Shifting the download command to use curl with sudo instead.
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

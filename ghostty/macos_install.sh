#! /bin/bash

# Ghostty terminal
brew install --cask ghostty
brew install --cask font-fira-mono-nerd-font

mkdir -p ~/.config/ghostty
ln -sf ~/.dotfiles/ghostty/config ~/.config/ghostty/config

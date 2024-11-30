#! /bin/bash

# Wezterm terminal
brew install --cask wezterm

ln -sf ~/.dotfiles/wezterm/wezterm.lua ~/.wezterm.lua

# Yazi
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release
sudo ln -sf ~/.dotfiles/wezterm/yazi/target/release/yazi /usr/bin/yazi


#! /bin/bash

# Wezterm terminal
curl -LO https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/wezterm-20230712-072601-f4abf8fd.Ubuntu22.04.deb
sudo apt install -y ./wezterm-20230712-072601-f4abf8fd.Ubuntu22.04.deb

ln -sf ~/.dotfiles/wezterm/wezterm.lua ~/.wezterm.lua

# Yazi
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release
sudo ln -sf ~/.dotfiles/wezterm/yazi/target/release/yazi /usr/bin/yazi


#!/bin/bash
# manjaro configuration
echo "Setting up manjaro..."

# automatically select fastest mirror
echo "Choosing the fastest mirror..."
sudo pacman-mirrors -c China

# install all needed dependencies
sudo pacman -Sy --needed wget git vim neovim

#!/bin/bash
echo "Setting up manjaro..."

# select & use fastest mirror
sudo pacman-mirrors -c China
# install all needed dependencies
sudo pacman -Sy --needed wget git neovim

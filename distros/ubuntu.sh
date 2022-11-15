#!/bin/bash

# ubuntu initialization
echo "Setting up ubuntu..."

# make sure we have sudo
if ! command -v sudo > /dev/null; then
    apt update
    apt install -y sudo
fi

# change mirror site
# sjtug
sudo sed -i 's/http:\/\/\([a-z]\{2\}.\)\?archive.ubuntu.com/http:\/\/mirror.sjtu.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/https:\/\/\([a-z]\{2\}.\)\?archive.ubuntu.com/https:\/\/mirror.sjtu.edu.cn/g' /etc/apt/sources.list

# apt update, install essential components
sudo apt update
sudo apt install -y wget git file
sudo apt upgrade -y vim
sudo apt install -y neovim zsh
sudo apt install -y kitty-terminfo

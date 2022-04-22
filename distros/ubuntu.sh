#!/bin/bash

# ubuntu initialization
echo "Setting up ubuntu..."

# make sure we have sudo
if ! command -v sudo > /dev/null; then
    apt update
    apt install -y sudo
fi

# change mirror site

# tuna
# sudo sed -i 's/cn.archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
# sudo sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

# sjtug
sudo sed -i 's/cn.archive.ubuntu.com/mirror.sjtu.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/mirror.sjtu.edu.cn/g' /etc/apt/sources.list

# apt update, install essential components
sudo apt update
sudo apt install -y wget git file
sudo apt upgrade -y vim
sudo apt install -y neovim zsh

#!/bin/bash
# common setup code for ubuntu to make it easier to use
echo "Setting up ubuntu..."

# make sure we have sudo
if ! command -v sudo > /dev/null; then
    apt update
    apt install -y sudo
fi

# change mirror site
# tuna
# sudo sed -i 's/cn.archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
# sudo sed -i 's/us.archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
# sudo sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

# sjtug
# sudo sed -i 's/cn.archive.ubuntu.com/mirror.sjtu.edu.cn/g' /etc/apt/sources.list
# sudo sed -i 's/us.archive.ubuntu.com/mirror.sjtu.edu.cn/g' /etc/apt/sources.list
# sudo sed -i 's/archive.ubuntu.com/mirror.sjtu.edu.cn/g' /etc/apt/sources.list

# ustc
sudo sed -i 's/cn.archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/us.archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# add repository for latest neovim
sudo add-apt-repository ppa:neovim-ppa/stable

# update & install all essential components
sudo apt update
sudo apt upgrade -y vim
sudo apt install -y wget git file neovim zsh kitty-terminfo

echo "Done! Enjoy~"

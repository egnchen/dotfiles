#!/bin/sh

# ubuntu initialization

# make sure we have sudo
if ! command -v sudo > /dev/null; then
    apt update
    apt install -y sudo
fi

# change mirror site
sudo sed -i 's/cn.archive.ubuntu.com/mirrors.sjtug.sjtu.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/mirrors.sjtug.sjtu.edu.cn/g' /etc/apt/sources.list

# apt update, install essential components
sudo apt update
sudo apt install -y curl git

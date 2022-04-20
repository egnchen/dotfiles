#!/bin/bash

# setup vim
if ! command -v vim > /dev/null; then
    echo "Vim not installed."
    exit 1
fi

# install amix/vimrc
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# link my config to .vim_runtime
dotfiles_vim_path=$(dirname ${BASH_SOURCE[0]})
dotfiles_vim_path=$(realpath ${dotfiles_vim_path})
ln -s $dotfiles_vim_path/my_configs.vim ~/.vim_runtime/my_configs.vim

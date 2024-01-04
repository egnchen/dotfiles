#!/bin/bash
if ! command -v nvim > /dev/null; then
  echo "nvim not installed"
  exit 1
fi

git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

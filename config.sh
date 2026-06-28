#!/bin/sh

REPO_BASE="https://raw.githubusercontent.com/NoamFav/42-boot/main"
NVIM_REPO="https://github.com/NoamFav/nvim-config.git"
ZSH_REPO="https://github.com/NoamFav/zsh.git"
NVIM_DIR="$HOME/.config/nvim"
ZSH_DIR="$HOME/.config/zsh"

. ./ui.sh
. ./clone.sh
. ./helpers.sh
. ./nvim-loader/alias.sh
. ./vim-loader/install-vim.sh
. ./shell-scan/install-bash.sh

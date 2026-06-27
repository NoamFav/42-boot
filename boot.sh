#!/bin/sh

has() { command -v "$1" >/dev/null 2>&1; }

REPO_BASE="https://raw.githubusercontent.com/NoamFav/42-boot/main"
NVIM_REPO="https://github.com/NoamFav/nvim-config.git"
ZSH_REPO="https://github.com/NoamFav/zsh.git"
NVIM_DIR="$HOME/.config/nvim"
ZSH_DIR="$HOME/.config/zsh"

. ./clone.sh
. ./nvim-loader/alias.sh
. ./vim-loader/install.sh
. ./shell-scan/shell.sh

shell

echo "Which shell do you want to install config for."
printf "Choose: [0] zsh [1] bash [2] fish : "
read -r choice_shell </dev/tty
case "$choice_shell" in
0)
    if has zsh; then
        echo "installing .zshrc"
        install_config "$ZSH_REPO" "$ZSH_DIR" "42-cluster" # clone/pull the modules
        ln -sf "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
    else
        echo "zsh not available, install it boo"
    fi
    if [ "$DEFAULT" != "zsh" ]; then
        echo "Zsh isnt default, run chsh -s $(command -v zsh) to make it default"
    fi
    ;;
1)
    if has bash; then
        echo "installing .bashrc"
        # install bash
    else
        echo "bash not available, sorry"
    fi
    if [ "$DEFAULT" != "bash" ]; then
        echo "Bash isnt default, run chsh -s $(command -v bash) to make it default"
    fi
    ;;
2)
    echo "I refuse to install fishrc, out of pride and you should see a therapist"
    ;;
esac

echo "Which text editor would you want to install"
printf "Choose: [0] both [1] nvim only [2] vim only [3] skip : "
read -r choice </dev/tty
case "$choice" in
0)
    has vim && install_vim || echo "vim missing, skipping"
    has nvim && install_config "$NVIM_REPO" "$NVIM_DIR" || echo "nvim missing, skipping"
    ;;
1)
    if has nvim; then
        install_config "$NVIM_REPO" "$NVIM_DIR"
    else
        echo "nvim unavailable"
    fi
    ;;
2)
    if has vim; then
        install_vim
    else
        echo "vim unavailable"
    fi
    ;;
3) echo "skip" ;;
*) echo "invalid, defaulting to skip" ;;
esac

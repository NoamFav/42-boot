#!/bin/sh

. ./shell-scan/shell.sh
. ./vim-loader/vim.sh
. ./nvim-loader/nvim.sh

echo "Which shell do you want to install config for."
printf "Choose: [0] zsh [1] bash [2] fish : "
read -r choice_shell </dev/tty
case "$choice_shell" in
0)
    if [ -n "$isZsh" ]; then
        echo "installing .zshrc"
        . ./shell-scan/zsh-install.sh
    else
        echo "zsh not available, install it boo"
    fi
    if [ "$DEFAULT" != "zsh" ]; then
        echo "Zsh isnt default, run chsh -s $(command -v zsh) to make it default"
    fi
    ;;
1)
    if [ -n "$isBash" ]; then
        echo "installing .bashrc"
        . ./shell-scan/bash-install.sh
    else
        echo "bash not available, sorry"
    fi
    if [ "$DEFAULT" != "bash" ]; then
        echo "Bash isnt default, edit \$SHELL"
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
    echo "both"
    . ./nvim-loader/install.sh
    . ./vim-loader/install.sh
    ;;
1)
    if [ "$NVIM_AVAILABLE" -eq 1 ]; then
        echo "nvim only"
        . ./nvim-loader/install.sh
    else
        echo "nvim unavailable"
    fi
    ;;
2)
    if [ "$VIM_AVAILABLE" -eq 1 ]; then
        echo "vim only"
        . ./vim-loader/install.sh
    else
        echo "vim unavailable"
    fi
    ;;
3) echo "skip" ;;
*) echo "invalid, defaulting to skip" ;;
esac

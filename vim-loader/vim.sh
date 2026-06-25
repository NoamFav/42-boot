#!/bin/sh

if [ -n "$(command -v vim)" ]; then
    echo "vim present (thank god)"
    VIM_AVAILABLE=1
else
    echo "vim absent (You must install it)"
    VIM_AVAILABLE=0
fi

echo "all path for it: $(which -a vim)"

#!/bin/sh

if command -v nvim >/dev/null 2>&1; then
    echo "nvim present (thank god)"
    NVIM_AVAILABLE=1
else
    echo "nvim absent (You must install it)"
    NVIM_AVAILABLE=0
fi

echo "all path for it: $(which -a nvim)"

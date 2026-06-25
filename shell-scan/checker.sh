#!/bin/sh

echo "Checking which shell is available (hope for zsh)"

isBash=$(command -v bash)
isZsh=$(command -v zsh)
isFish=$(command -v fish)
isSh=$(command -v sh)

if [ -n "$isBash" ]; then
    echo "Bash detected at $isBash"
else
    echo "Bash missing (zsh????)"
fi

if [ -n "$isZsh" ]; then
    echo "Zsh detected at $isZsh, YAYYYYY"
else
    echo "zsh missing (definitely consider installing it)"
fi

if [ -n "$isFish" ]; then
    echo "Fish detected at $isFish, why would you do that to yourselg"
else
    echo "Fish missing (not a big woop :/)"
fi

if [ -n "$isSh" ]; then
    echo "Shell detected at $isSh, at least thats a backup"
else
    echo "Shell missing (yeah thats a problem)"
fi

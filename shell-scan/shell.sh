#!/bin/sh

echo "Checking which shell is available (hope for zsh)"

shell=$(echo "$SHELL")

isBash=$(command -v bash)
isZsh=$(command -v zsh)
isFish=$(command -v fish)
isSh=$(command -v sh)

if [ -n "$isBash"]; then
    echo "Bash detected at $isBash"
fi

if [ -n "$isZsh"]; then
    echo "Bash detected at $isZsh"
fi

if [ -n "$isFish"]; then
    echo "Bash detected at $isFish"
fi

if [ -n "$isSh"]; then
    echo "Bash detected at $isSh"
fi

case "$SHELL" in
*zsh*)
    echo "default is zsh"
    ;;
*bash*)
    echo "default is bash"
    ;;
*fish*)
    echo "default is fish"
    ;;
*shell*)
    echo "default is shell"
    ;;
*)
    echo "somehow something else, really weird :("
    ;;
esac

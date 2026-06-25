#!/bin/sh

. ./shell-scan/checker.sh

case "$SHELL" in
*zsh*)
    echo "default is zsh"
    DEFAULT="zsh"
    ;;
*bash*)
    echo "default is bash"
    DEFAULT="bash"
    ;;
*fish*)
    echo "default is fish"
    DEFAULT="fish"
    ;;
*/sh)
    echo "default is shell"
    DEFAULT="sh"
    ;;
*)
    echo "somehow something else, really weird :("
    ;;
esac

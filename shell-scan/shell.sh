#!/bin/sh

shell() {
    case "$SHELL" in
    *zsh*) DEFAULT="zsh" ;;
    *bash*) DEFAULT="bash" ;;
    *fish*) DEFAULT="fish" ;;
    */sh) DEFAULT="sh" ;;
    *) DEFAULT="unknown" ;;
    esac
}

#!/bin/sh

install_config() {
    repo="$1"
    dest="$2"
    branch="${3:-}"
    if [ -d "$dest/.git" ]; then
        current=$(git -C "$dest" remote get-url origin 2>/dev/null)
        if [ "$current" = "$repo" ]; then
            echo "config present, updating"
            git -C "$dest" pull
        else
            echo "different repo at $dest, backing up"
            mv "$dest" "$dest.backup-$(date +%s)"
            clone_config "$repo" "$dest" "$branch"
        fi
    else
        [ -d "$dest" ] && mv "$dest" "$dest.backup-$(date +%s)"
        clone_config "$repo" "$dest" "$branch"
    fi
}

clone_config() {
    if [ -n "$3" ]; then
        git clone -b "$3" "$1" "$2"
    else
        git clone "$1" "$2"
    fi
}

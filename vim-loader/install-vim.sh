#!/bin/sh

install_vim() {
    VIMRC_URL="$REPO_BASE/vim-loader/.vimrc"
    [ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$HOME/.vimrc.backup-$(date +%s)"
    if curl -fsSL "$VIMRC_URL" -o "$HOME/.vimrc"; then
        ok "vimrc installed"
    else
        err "failed to fetch vimrc"
    fi
}

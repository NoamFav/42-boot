#!/bin/sh

install_bashrc() {
    BASHRC_URL="$REPO_BASE/shell-scan/.bashrc"
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.backup-$(date +%s)"
    if curl -fsSL "$BASHRC_URL" -o "$HOME/.bashrc"; then
        ok "bashrc installed"
    else
        err "failed to fetch bashrc"
    fi
}

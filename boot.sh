#!/bin/sh

. ./config.sh

banner
info "host:    ${C_BOLD}${DISTRO}${C_RESET}"
info "shell:   ${C_BOLD}${DEFAULT}${C_RESET}"
info "pkg-mgr: ${C_BOLD}${PM}${C_RESET}"
echo

choose choice_shell "Which shell config do you want?" 0 \
    "zsh   — NoamFav/zsh (42-cluster branch), symlinked to ~/.zshrc" \
    "bash  — standalone .bashrc" \
    "fish  — not provided"

case "$choice_shell" in
0)
    if ensure_tool zsh; then
        info "installing zsh config…"
        if install_config "$ZSH_REPO" "$ZSH_DIR" "42-cluster"; then
            ln -sf "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
            ok "zsh config linked to ~/.zshrc"
            [ "$DEFAULT" != "zsh" ] &&
                warn "zsh isn't your login shell — run: ${C_BOLD}chsh -s $(command -v zsh)${C_RESET}"
        else
            err "zsh config install failed — left ~/.zshrc untouched"
        fi
    fi
    ;;
1)
    if ensure_tool bash; then
        info "installing bash config…"
        install_bashrc
        [ "$DEFAULT" != "bash" ] &&
            warn "bash isn't your login shell — run: ${C_BOLD}chsh -s $(command -v bash)${C_RESET}"
    fi
    ;;
2)
    warn "no fish config provided — skipping."
    ;;
esac

echo

# --------------------------------------------------------------- editor config
choose choice_editor "Which editor config do you want?" 1 \
    "both  — nvim + vim" \
    "nvim  — NoamFav/nvim-config" \
    "vim   — standalone .vimrc" \
    "skip"

install_nvim() {
    if ensure_tool nvim neovim; then
        info "installing nvim config…"
        install_config "$NVIM_REPO" "$NVIM_DIR" && ok "nvim config installed"
        nvim_alias # set up a Flatpak alias if needed (see nvim-loader/alias.sh)
    fi
}

install_vim_cfg() {
    if ensure_tool vim; then
        info "installing vim config…"
        install_vim
    fi
}

case "$choice_editor" in
0)
    install_vim_cfg
    install_nvim
    ;;
1) install_nvim ;;
2) install_vim_cfg ;;
3) info "skipping editor config" ;;
*) info "skipping editor config" ;;
esac

echo
ok "${C_BOLD}all done.${C_RESET}"

#!/bin/sh



if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    C_RESET='\033[0m'
    C_BOLD='\033[1m'
    C_DIM='\033[2m'
    C_RED='\033[31m'
    C_GREEN='\033[32m'
    C_YELLOW='\033[33m'
    C_BLUE='\033[34m'
    C_MAGENTA='\033[35m'
    C_CYAN='\033[36m'
else
    C_RESET='' C_BOLD='' C_DIM='' C_RED='' C_GREEN='' \
        C_YELLOW='' C_BLUE='' C_MAGENTA='' C_CYAN=''
fi

say()  { printf '%b\n' "$*"; }
info() { printf '%b\n' "${C_CYAN}→${C_RESET} $*"; }
ok()   { printf '%b\n' "${C_GREEN}✔${C_RESET} $*"; }
warn() { printf '%b\n' "${C_YELLOW}!${C_RESET} $*"; }
err()  { printf '%b\n' "${C_RED}✘${C_RESET} $*"; }

banner() {
    printf '%b\n' "${C_MAGENTA}${C_BOLD}"
    printf '%s\n' "  ╭────────────────────────────────────────────╮"
    printf '%s\n' "  │   42-boot · fresh-box config bootstrap     │"
    printf '%s\n' "  ╰────────────────────────────────────────────╯"
    printf '%b\n' "${C_RESET}"
}

confirm() {
    printf '%b' "${C_YELLOW}?${C_RESET} ${C_BOLD}$1${C_RESET} ${C_DIM}[Y/n]${C_RESET} "
    read -r _ans </dev/tty
    case "$_ans" in
    [Nn] | [Nn][Oo]) return 1 ;;
    *) return 0 ;;
    esac
}

choose() {
    _var="$1"
    _prompt="$2"
    _default="$3"
    shift 3
    printf '%b\n' "${C_BOLD}${_prompt}${C_RESET}"
    _n=0
    for _opt in "$@"; do
        printf '   %b[%d]%b %s\n' "$C_CYAN" "$_n" "$C_RESET" "$_opt"
        _n=$((_n + 1))
    done
    while :; do
        printf '%b' "${C_CYAN}?${C_RESET} choose ${C_DIM}[default ${_default}]${C_RESET}: "
        read -r _ans </dev/tty
        [ -z "$_ans" ] && _ans="$_default"
        case "$_ans" in
        *[!0-9]*) ;;
        *)
            if [ "$_ans" -ge 0 ] && [ "$_ans" -lt "$_n" ]; then
                eval "$_var=\$_ans"
                return 0
            fi
            ;;
        esac
        warn "invalid choice — pick 0 to $((_n - 1))"
    done
}


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


has() { command -v "$1" >/dev/null 2>&1; }

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif has sudo; then
    SUDO="sudo"
else
    SUDO=""
fi

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO="$ID"
        DISTRO_LIKE="$ID_LIKE"
    else
        DISTRO="unknown"
    fi
}

detect_pm() {
    if has apt-get; then
        PM="apt"
    elif has dnf; then
        PM="dnf"
    elif has pacman; then
        PM="pacman"
    elif has zypper; then
        PM="zypper"
    elif has brew; then
        PM="brew"
    elif has apk; then
        PM="apk"
    else
        PM="unknown"
    fi
}

install_pkg() {
    case "$PM" in
    apt) $SUDO apt-get install -y "$1" ;;
    dnf) $SUDO dnf install -y "$1" ;;
    pacman) $SUDO pacman -S --noconfirm "$1" ;;
    zypper) $SUDO zypper install -y "$1" ;;
    apk) $SUDO apk add "$1" ;;
    brew) brew install "$1" ;;
    *) return 1 ;;
    esac
}

ensure_tool() {
    cmd="$1"
    pkg="${2:-$1}"
    if has "$cmd"; then
        return 0
    fi
    warn "$cmd is not installed."
    if [ "$PM" = "unknown" ]; then
        err "no known package manager — install $cmd manually, then re-run."
        return 1
    fi
    if confirm "install $cmd with $PM?"; then
        if install_pkg "$pkg" && has "$cmd"; then
            ok "$cmd installed."
            return 0
        fi
        err "failed to install $cmd."
        return 1
    fi
    info "skipping $cmd."
    return 1
}

shell() {
    case "$SHELL" in
    *zsh*) DEFAULT="zsh" ;;
    *bash*) DEFAULT="bash" ;;
    *fish*) DEFAULT="fish" ;;
    */sh) DEFAULT="sh" ;;
    *) DEFAULT="unknown" ;;
    esac
}

shell
detect_distro
detect_pm


REPO_BASE="https://raw.githubusercontent.com/NoamFav/42-boot/main"
NVIM_REPO="https://github.com/NoamFav/nvim-config.git"
ZSH_REPO="https://github.com/NoamFav/zsh.git"
NVIM_DIR="$HOME/.config/nvim"
ZSH_DIR="$HOME/.config/zsh"




NVIM_FLATPAK_ID="io.neovim.nvim"

nvim_alias() {
    if has nvim; then
        return 0
    fi
    if has flatpak && flatpak info "$NVIM_FLATPAK_ID" >/dev/null 2>&1; then
        line="alias nvim='flatpak run $NVIM_FLATPAK_ID'"
        rc="$ZSH_DIR/.zshrc"
        if [ -f "$rc" ] && ! grep -qF "$line" "$rc"; then
            printf '\n# 42-boot: Neovim via Flatpak\n%s\n' "$line" >>"$rc"
            ok "added Flatpak nvim alias to zsh config"
        fi
    fi
}


install_vim() {
    VIMRC_URL="$REPO_BASE/vim-loader/.vimrc"
    [ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$HOME/.vimrc.backup-$(date +%s)"
    if curl -fsSL "$VIMRC_URL" -o "$HOME/.vimrc"; then
        ok "vimrc installed"
    else
        err "failed to fetch vimrc"
    fi
}


install_bashrc() {
    BASHRC_URL="$REPO_BASE/shell-scan/.bashrc"
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.backup-$(date +%s)"
    if curl -fsSL "$BASHRC_URL" -o "$HOME/.bashrc"; then
        ok "bashrc installed"
    else
        err "failed to fetch bashrc"
    fi
}



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

choose choice_editor "Which editor config do you want?" 1 \
    "both  — nvim + vim" \
    "nvim  — NoamFav/nvim-config" \
    "vim   — standalone .vimrc" \
    "skip"

install_nvim() {
    if ensure_tool nvim neovim; then
        info "installing nvim config…"
        install_config "$NVIM_REPO" "$NVIM_DIR" && ok "nvim config installed"
        nvim_alias
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

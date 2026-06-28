#!/bin/sh

has() { command -v "$1" >/dev/null 2>&1; }

# Run privileged installs as the user if root, via sudo otherwise, or bare if
# sudo is unavailable (the install will simply fail loudly without it).
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

# install_pkg <package> — install a package with the detected manager.
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

# ensure_tool <command> [package] — guarantee a command is available, offering
# to install it via the detected package manager when it's missing.
# Returns 0 if the command is (now) present, 1 otherwise.
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

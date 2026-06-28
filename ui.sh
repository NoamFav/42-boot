#!/bin/sh

# Tiny output/prompt toolkit. Colors are disabled automatically when stdout
# isn't a terminal, or when NO_COLOR is set (https://no-color.org/).

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

# confirm "question?"  -> returns 0 for yes (default), 1 for no
confirm() {
    printf '%b' "${C_YELLOW}?${C_RESET} ${C_BOLD}$1${C_RESET} ${C_DIM}[Y/n]${C_RESET} "
    read -r _ans </dev/tty
    case "$_ans" in
    [Nn] | [Nn][Oo]) return 1 ;;
    *) return 0 ;;
    esac
}

# choose <varname> <prompt> <default-index> <opt0> <opt1> ...
# Prints a numbered menu and loops until a valid index is entered,
# storing the chosen number in the named variable.
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

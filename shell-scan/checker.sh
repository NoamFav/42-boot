#!/bin/sh

echo "Checking which shell is available (hope for zsh)"

isBash=$(command -v bash)
isZsh=$(command -v zsh)
isFish=$(command -v fish)
isSh=$(command -v sh)

check_shell() {
    name="$1"
    found_msg="$2"
    missing_msg="$3"
    path=$(command -v "$4")

    if [ -n "$path" ]; then
        echo "$name detected at $path, $found_msg"
    else
        echo "$name missing ($missing_msg)"
    fi
}

check_shell "Bash" "" "zsh????" "bash"
check_shell "Zsh" "YAYYYYY" "definitely consider installing it" "zsh"
check_shell "Fish" "why would you do that to yourself" "not a big woop :/" "fish"
check_shell "Shell" "at least thats a backup" "yeah thats a problem" "sh"

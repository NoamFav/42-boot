#!/bin/sh

# Neovim alias hook.
#
# When Neovim is installed as a Flatpak (common on locked-down boxes where you
# can't get a native package), the `nvim` command isn't on PATH — you have to
# go through `flatpak run io.neovim.nvim`. This hook is where that alias gets
# wired into the shell config so `nvim` Just Works.
#
# It's intentionally a no-op by default. Edit it down the line when/if you
# actually run Neovim via Flatpak — uncomment the block below and it'll be
# appended to the zsh config on install.

NVIM_FLATPAK_ID="io.neovim.nvim"

nvim_alias() {
    # Only relevant when there's no native nvim but a Flatpak one exists.
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

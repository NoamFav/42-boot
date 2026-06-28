#!/bin/sh

set -e

OUT="install.sh"

PARTS="ui.sh clone.sh helpers.sh config.sh nvim-loader/alias.sh vim-loader/install-vim.sh shell-scan/install-bash.sh boot.sh"

{
    echo "#!/bin/sh"
    for p in $PARTS; do
        echo ""

        grep -v -e '^#!/bin/sh' -e '^\. \./' -e '^[[:space:]]*#' "$p" |
            sed 's/[[:space:]][[:space:]]*#.*$//'
    done
} >"$OUT"

chmod +x "$OUT"
echo "wrote $OUT"

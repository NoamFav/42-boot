# 42-boot

A small POSIX-`sh` bootstrap script that sets up a fresh machine (built for the [42](https://42.fr/) cluster) with my shell and editor configs in one go. Run it on a clean box and pick what you want installed — it pulls the configs from their repos, backs up anything already there, and wires everything into place.

## What it does

On run, it asks two questions:

1. **Which shell config to install** — zsh (clones [`zsh`](https://github.com/NoamFav/zsh), `42-cluster` branch, and symlinks the loader to `~/.zshrc`), bash, or fish.
2. **Which editor config to install** — Neovim (clones [`nvim-config`](https://github.com/NoamFav/nvim-config)), Vim (fetches a standalone `.vimrc`), both, or skip.

Installs are **idempotent and safe**: existing configs are detected and updated rather than clobbered, and anything in the way is moved to a timestamped backup before cloning.

## Usage

Quickest — one-liner, no clone (runs the bundled `install.sh`):

```sh
curl -fsSL https://raw.githubusercontent.com/NoamFav/42-boot/main/install.sh | sh
```

Or clone and run the modular entry point:

```sh
git clone https://github.com/NoamFav/42-boot.git
cd 42-boot
sh boot.sh
```

The script is interactive — it reads your choices from `/dev/tty` as it goes, so the prompts work even when piped from `curl`.

> `install.sh` is generated from the modules by `sh build.sh` — edit the modules, not the bundle. The plain `curl … | boot.sh` form does **not** work, because `boot.sh` sources its sibling files relatively; use the bundled `install.sh` (above) or clone the repo.

## How it works

- **`boot.sh`** — entry point. Defines a `has()` helper (a `command -v` wrapper for checking tool availability), sets the repo/path variables, sources the modules, and drives the two interactive prompts.
- **`clone.sh`** — `install_config <repo> <dest> [branch]`, a generic clone-or-update function used for both the zsh and Neovim configs. If the destination is already a clone of the same repo it pulls; if it's a different repo or a non-git directory it backs up and clones fresh. An optional branch argument lets it check out a specific branch (used for the zsh `42-cluster` config).
- **`vim-loader/install.sh`** — fetches a standalone `.vimrc` over `curl`, backing up any existing one first.
- **`shell-scan/shell.sh`** — detects the current default shell from `$SHELL` so the script can tell you whether to run `chsh`.

### Config placement

Editor configs live where the editor reads them directly (`~/.config/nvim`). The zsh config clones to `~/.config/zsh` and then symlinks its loader to `~/.zshrc`, since zsh reads `~/.zshrc` from `$HOME` — the symlink bridges the two so edits to the cloned repo are picked up live.

## Notes

- The script **does not** change your default shell — if zsh isn't already your login shell, it prints the `chsh` command to run yourself (changing shells often needs the shell listed in `/etc/shells` and may prompt for a password).
- Built for a Linux cluster environment; the zsh config it pulls is the lean, Linux-appropriate `42-cluster` branch.

## License

MIT

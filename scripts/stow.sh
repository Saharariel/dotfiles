#!/usr/bin/env bash
# Symlink dotfile packages into $HOME using GNU stow.
# Shared packages go on every machine; the rest are picked per-OS.
set -euo pipefail

# Repo root is the parent of this script's directory.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES"

if ! command -v stow &>/dev/null; then
  echo "❌ stow not found. Install it first (run packages-*.sh)." >&2
  exit 1
fi

# Cross-platform configs (terminals, editor, shell, prompt).
SHARED=(zsh nvim tmux p10k ghostty kitty)

# Shell + editor only — for headless dev containers (no terminal emulator,
# no desktop). Skips ghostty/kitty since the terminal runs on the host.
CONTAINER=(zsh nvim tmux p10k)

# OS-specific desktop / window-manager configs.
MACOS=(aerospace sketchybar jankyborders)
LINUX=(hyprland waybar swayosd dunst)

# Treat Debian/Ubuntu as a dev-container target: shell+editor configs only.
is_debian() {
  [[ -r /etc/os-release ]] || return 1
  # shellcheck disable=SC1091
  . /etc/os-release
  [[ "${ID:-}" =~ ^(debian|ubuntu)$ || "${ID_LIKE:-}" == *debian* ]]
}

case "$(uname -s)" in
  Darwin) PACKAGES=("${SHARED[@]}" "${MACOS[@]}") ;;
  Linux)
    if is_debian; then
      PACKAGES=("${CONTAINER[@]}")
    else
      PACKAGES=("${SHARED[@]}" "${LINUX[@]}")
    fi
    ;;
  *) echo "❌ Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

# Dev-container base images ship real ~/.zshrc / ~/.bashrc files. stow won't
# overwrite real files (by design — we don't pass --adopt), so back up the ones
# we're about to replace to a .pre-stow copy, letting our symlinks take over.
# Only touch an rc file if its package is actually in PACKAGES — otherwise we'd
# strip e.g. the image's mise activation from a shell we never re-link.
declare -A RC_OF=( [zsh]=.zshrc [bash]=.bashrc )
for pkg in "${PACKAGES[@]}"; do
  rc="${RC_OF[$pkg]:-}"
  [[ -n "$rc" && -f "$HOME/$rc" && ! -L "$HOME/$rc" ]] || continue
  echo "→ Backing up existing $rc → $rc.pre-stow"
  mv "$HOME/$rc" "$HOME/$rc.pre-stow"
done

echo "→ Stowing: ${PACKAGES[*]}"
# --restow cleanly re-links (handles renamed/removed files); adopt is intentionally
# NOT used so existing real files are reported as conflicts instead of overwritten.
stow -v --restow --target="$HOME" "${PACKAGES[@]}"
echo "✓ Done."

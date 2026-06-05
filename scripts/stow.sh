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

# OS-specific desktop / window-manager configs.
MACOS=(aerospace sketchybar jankyborders)
LINUX=(hyprland waybar swayosd dunst)

case "$(uname -s)" in
  Darwin) PACKAGES=("${SHARED[@]}" "${MACOS[@]}") ;;
  Linux)  PACKAGES=("${SHARED[@]}" "${LINUX[@]}") ;;
  *) echo "❌ Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

echo "→ Stowing: ${PACKAGES[*]}"
# --restow cleanly re-links (handles renamed/removed files); adopt is intentionally
# NOT used so existing real files are reported as conflicts instead of overwritten.
stow -v --restow --target="$HOME" "${PACKAGES[@]}"
echo "✓ Done."

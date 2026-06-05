#!/usr/bin/env bash
# Dotfiles bootstrap: install packages for the current OS, then symlink configs.
# Usage: ./install.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES"

echo "========================================="
echo " Dotfiles bootstrap — $(uname -s)"
echo "========================================="

case "$(uname -s)" in
  Darwin) ./scripts/packages-macos.sh   ;;
  Linux)  ./scripts/packages-bazzite.sh ;;
  *) echo "❌ Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

./scripts/stow.sh

echo ""
echo "🎉 Bootstrap complete. Restart your shell:  exec zsh"

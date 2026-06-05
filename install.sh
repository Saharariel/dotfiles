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
  Darwin) ./scripts/packages-macos.sh ;;
  Linux)
    # Pick the Linux package path by distro family: Debian/Ubuntu (incl. dev
    # containers) use apt; everything else falls back to the Bazzite/brew path.
    distro_id=""; distro_like=""
    if [[ -r /etc/os-release ]]; then
      # shellcheck disable=SC1091
      . /etc/os-release
      distro_id="${ID:-}"; distro_like="${ID_LIKE:-}"
    fi
    if [[ "$distro_id" =~ ^(debian|ubuntu)$ || "$distro_like" == *debian* ]]; then
      ./scripts/packages-debian.sh
    else
      ./scripts/packages-bazzite.sh
    fi
    ;;
  *) echo "❌ Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

./scripts/stow.sh

echo ""
echo "🎉 Bootstrap complete. Restart your shell:  exec zsh"

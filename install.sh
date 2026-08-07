#!/usr/bin/env bash
# Dotfiles bootstrap: install packages for the current OS, then symlink configs.
# Usage: ./install.sh [--profile PROFILE] [--dry-run]
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES"

usage() {
  cat <<'EOF'
Usage: ./install.sh [OPTIONS]

Options:
  --profile PROFILE  macos-work, bazzite-hyprland, or devcontainer
  --dry-run          Show the selected actions without changing files
  -h, --help         Show this help
EOF
}

PROFILE=""
DRY_RUN=0
while (($#)); do
  case "$1" in
    --profile) [[ $# -ge 2 ]] || { echo "Missing profile name" >&2; exit 2; }; PROFILE="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  case "$(uname -s)" in
    Darwin) PROFILE=macos-work ;;
    Linux)
      if [[ -r /etc/os-release ]]; then . /etc/os-release; fi
      if [[ "${ID:-}" =~ ^(debian|ubuntu)$ || "${ID_LIKE:-}" == *debian* ]]; then
        PROFILE=devcontainer
      else
        PROFILE=bazzite-hyprland
      fi
      ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
  esac
fi

case "$PROFILE" in
  macos-work|bazzite-hyprland|devcontainer) ;;
  *) echo "Unsupported profile: $PROFILE" >&2; usage >&2; exit 2 ;;
esac

echo "========================================="
echo " Dotfiles bootstrap - $PROFILE"
echo "========================================="

if ((DRY_RUN)); then
  echo "Dry run: package installation and linking are skipped."
else
  case "$PROFILE" in
    macos-work) ./scripts/packages-macos.sh ;;
    bazzite-hyprland) ./scripts/packages-bazzite.sh ;;
    devcontainer) ./scripts/packages-debian.sh ;;
  esac
  ./scripts/stow.sh --profile "$PROFILE"
fi
./scripts/doctor.sh --profile "$PROFILE"

echo ""
echo "Bootstrap complete. Restart your shell with: exec zsh"

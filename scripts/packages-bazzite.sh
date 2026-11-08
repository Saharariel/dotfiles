#!/usr/bin/env bash
set -euo pipefail

# ============================================
# Bazzite (immutable Fedora) package setup
# ============================================
# Layers of this machine, each with exactly one source of truth:
#   • OS image   → ghcr.io/saharariel/bazzite-hyprland (Bazzite DX + Hyprland
#                  stack), built from github.com/Saharariel/bazzite-hyprland.
#                  Nothing is layered with rpm-ostree.
#   • Brewfile   → packages/bazzite.Brewfile: CLI tools, fonts (casks),
#                  flatpak GUI apps, npm/go tools. Refresh it with
#                  `brew bundle dump --force --no-vscode --file packages/bazzite.Brewfile`.
#   • upstream   → apps installed through their official installer (below).
#   • dotfiles   → configs, linked by scripts/stow.sh.

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$DOTFILES/packages/bazzite.Brewfile"
IMAGE="ghcr.io/saharariel/bazzite-hyprland"

# Official upstream installers
VICINAE_INSTALL_URL="https://vicinae.com/install"

# ============================================
# HELPERS
# ============================================
print_header()  { echo ""; echo "========================================="; echo "$1"; echo "========================================="; }
print_success() { echo "✓ $1"; }
print_info()    { echo "→ $1"; }
print_skip()    { echo "⊘ $1 (already installed)"; }
print_warn()    { echo "⚠ $1"; }

# ============================================
# MAIN
# ============================================
print_header "Bazzite Environment Setup"

# --- OS image ---
print_header "Checking OS Image"
booted_image="$(rpm-ostree status --booted --json | jq -r '.deployments[0]["container-image-reference"] // ""')"
layered="$(rpm-ostree status --booted --json | jq -r '.deployments[0]["requested-packages"] | length')"
if [[ "$booted_image" == *"$IMAGE"* ]]; then
  print_success "Booted from $IMAGE"
else
  print_warn "Booted image is: ${booted_image:-unknown}"
  echo "   Switch to the custom image, then reboot:"
  echo "     sudo rpm-ostree reset"
  echo "     sudo rpm-ostree rebase ostree-unverified-registry:$IMAGE:latest"
  echo "   After that first boot, enforce signatures:"
  echo "     sudo rpm-ostree rebase ostree-image-signed:docker://$IMAGE:latest"
fi
if ((layered > 0)); then
  print_warn "$layered rpm-ostree layered package(s). Move them into the image repo instead."
fi

# --- Homebrew (Linuxbrew) ---
if ! command -v brew &>/dev/null; then
  if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    echo "❌ Homebrew not found. Install from https://brew.sh then re-run." >&2
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
    exit 1
  fi
fi
print_success "Homebrew found: $(brew --version | head -n1)"

# --- Brewfile: CLI tools, fonts, flatpaks, npm/go tools ---
print_header "Installing Brewfile ($BREWFILE)"
if ! flatpak remotes --columns=name | grep -qx flathub; then
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi
brew bundle install --file="$BREWFILE"
print_success "Brewfile satisfied"

# --- upstream applications ---
print_header "Installing Upstream Applications"
if command -v vicinae &>/dev/null; then
  print_skip "Vicinae"
else
  print_info "Installing Vicinae..."
  curl -fsSL "$VICINAE_INSTALL_URL" | bash
  print_success "Vicinae installed"
fi

print_header "Done"
cat <<'NOTES'

NOTES:
  • Not covered here, restore from backup: ~/.ssh, secrets, browser profiles,
    Steam library, distrobox containers (e.g. "airplay").
  • After this, run `exec zsh` to reload your shell.
NOTES

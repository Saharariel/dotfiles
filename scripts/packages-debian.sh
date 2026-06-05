#!/usr/bin/env bash
set -euo pipefail

# ============================================
# Debian / Ubuntu package setup
# ============================================
# Used for dev containers (DevPod, devcontainers) and bare-metal Debian/Ubuntu.
# Unlike macOS/Bazzite there's no Homebrew here, so:
#   • apt        → CLI tools that are packaged and recent enough
#   • git clone  → powerlevel10k + zsh plugins (no apt/brew package in-container)
#   • release dl → fzf (apt's is too old for `fzf --zsh`, used by .zshrc)
# This path installs NO desktop/WM stack — containers are headless.

# apt packages (CLI tools & shell). zsh must be a real system shell here
# (the dotfiles use it as the login shell), so it can't come from a version manager.
APT_PACKAGES=(
  zsh
  git
  curl
  wget
  htop
  stow
  tmux
  neovim
  zoxide
  fontconfig   # for `fc-cache`, used to register the MesloLGS Nerd Font p10k wants
)

# powerlevel10k + zsh plugins, cloned into XDG data dir. The .zshrc sources these
# from here when Homebrew isn't present (see "Tools" / "Plugins" sections there).
ZSH_DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
declare -A ZSH_REPOS=(
  [powerlevel10k]="https://github.com/romkatv/powerlevel10k.git"
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  [zsh-vi-mode]="https://github.com/jeffreytse/zsh-vi-mode.git"
)

FZF_VERSION="0.57.0"

# ============================================
# HELPERS
# ============================================
print_header()  { echo ""; echo "========================================="; echo "$1"; echo "========================================="; }
print_success() { echo "✓ $1"; }
print_info()    { echo "→ $1"; }
print_skip()    { echo "⊘ $1 (already present)"; }

# sudo only if we're not already root (containers often run as root).
SUDO=""
[[ "$(id -u)" -ne 0 ]] && SUDO="sudo"

# ============================================
# MAIN
# ============================================
print_header "Debian/Ubuntu Environment Setup"

print_header "Installing apt packages"
export DEBIAN_FRONTEND=noninteractive
$SUDO apt-get update
$SUDO apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"
print_success "apt packages installed: ${APT_PACKAGES[*]}"

print_header "Cloning powerlevel10k + zsh plugins"
mkdir -p "$ZSH_DATA"
for name in "${!ZSH_REPOS[@]}"; do
  dest="$ZSH_DATA/$name"
  if [[ -d "$dest/.git" ]]; then
    print_skip "$name"
  else
    print_info "Cloning $name..."
    git clone --depth=1 "${ZSH_REPOS[$name]}" "$dest"
    print_success "$name"
  fi
done

print_header "Installing fzf $FZF_VERSION"
if command -v fzf &>/dev/null && fzf --version 2>/dev/null | grep -q "$FZF_VERSION"; then
  print_skip "fzf $FZF_VERSION"
else
  case "$(uname -m)" in
    x86_64)  fzf_arch=amd64 ;;
    aarch64|arm64) fzf_arch=arm64 ;;
    *) echo "⚠ unsupported arch $(uname -m) — skipping fzf"; fzf_arch="" ;;
  esac
  if [[ -n "$fzf_arch" ]]; then
    print_info "Downloading fzf..."
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${fzf_arch}.tar.gz" \
      | $SUDO tar -xz -C /usr/local/bin fzf
    print_success "fzf $FZF_VERSION"
  fi
fi

print_header "Done"
echo "📦 apt: ${#APT_PACKAGES[@]} · zsh repos: ${#ZSH_REPOS[@]} · fzf: $FZF_VERSION"
echo "→ stow.sh will now symlink your configs; run 'exec zsh' afterwards."

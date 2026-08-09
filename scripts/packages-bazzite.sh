#!/usr/bin/env bash
set -euo pipefail

# ============================================
# Bazzite (immutable Fedora) package setup
# ============================================
# Strategy on an atomic/immutable distro:
#   • Homebrew  → CLI tools & shell stuff (no reboot, same as macOS)
#   • flatpak   → GUI applications
#   • upstream  → apps installed through their official installer
#   • rpm-ostree→ system-level packages only (LAST resort; needs a reboot)
# The Hyprland/Wayland desktop stack on Bazzite is best installed via its own
# image/ujust workflow — see NOTES at the bottom rather than layering it here.

# CLI Tools & Utilities (Homebrew — mirrors packages-macos.sh)
CLI_TOOLS=(
  git
  lazygit
  wget
  htop
  neovim
  tree-sitter-cli
  tmux
  fzf
  zoxide
  stow
)

# Shell Enhancements (Homebrew)
SHELL_TOOLS=(
  powerlevel10k
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-vi-mode
)

# GUI Applications (flatpak app IDs)
FLATPAKS=(
  # com.mitchellh.ghostty
  # dev.zed.Zed
)

# Official upstream installers
VICINAE_INSTALL_URL="https://vicinae.com/install"

# System packages that genuinely need to be layered on the base image.
# Each entry here triggers a reboot to apply. Keep this list as small as possible.
RPM_OSTREE=(
  # zsh   # already shipped on Bazzite; uncomment only if missing
)

# ============================================
# HELPERS
# ============================================
print_header()  { echo ""; echo "========================================="; echo "$1"; echo "========================================="; }
print_success() { echo "✓ $1"; }
print_info()    { echo "→ $1"; }
print_skip()    { echo "⊘ $1 (already installed)"; }

brew_install() {
  local pkg="$1"
  if brew list --formula "$pkg" &>/dev/null; then
    print_skip "$pkg"
  else
    print_info "Installing $pkg..."
    brew install "$pkg"
    print_success "$pkg installed"
  fi
}

# ============================================
# MAIN
# ============================================
print_header "Bazzite Environment Setup"

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

print_header "Updating Homebrew"
brew update

print_header "Installing CLI Tools & Utilities"
for pkg in "${CLI_TOOLS[@]}"; do brew_install "$pkg"; done

print_header "Installing Shell Enhancements"
for pkg in "${SHELL_TOOLS[@]}"; do brew_install "$pkg"; done

# --- upstream applications ---
print_header "Installing Upstream Applications"
if command -v vicinae &>/dev/null; then
  print_skip "Vicinae"
else
  print_info "Installing Vicinae..."
  curl -fsSL "$VICINAE_INSTALL_URL" | bash
  print_success "Vicinae installed"
fi

# --- flatpak GUI apps ---
if ((${#FLATPAKS[@]})); then
  print_header "Installing Flatpak Applications"
  if ! command -v flatpak &>/dev/null; then
    echo "⚠ flatpak not found — skipping GUI apps."
  else
    flatpak remote-add --if-not-exists --user flathub \
      https://dl.flathub.org/repo/flathub.flatpakrepo || true
    for app in "${FLATPAKS[@]}"; do
      if flatpak info "$app" &>/dev/null; then
        print_skip "$app"
      else
        print_info "Installing $app..."
        flatpak install -y --user flathub "$app"
        print_success "$app installed"
      fi
    done
  fi
fi

# --- rpm-ostree layered packages (reboot required) ---
if ((${#RPM_OSTREE[@]})); then
  print_header "Layering System Packages (rpm-ostree)"
  to_install=()
  for pkg in "${RPM_OSTREE[@]}"; do
    if rpm -q "$pkg" &>/dev/null; then
      print_skip "$pkg"
    else
      to_install+=("$pkg")
    fi
  done
  if ((${#to_install[@]})); then
    print_info "Layering: ${to_install[*]}"
    sudo rpm-ostree install "${to_install[@]}"
    echo "⚠ Reboot required to apply layered packages."
  fi
fi

print_header "Done"
echo "📦 CLI: ${#CLI_TOOLS[@]} · Shell: ${#SHELL_TOOLS[@]} · Upstream: Vicinae · Flatpaks: ${#FLATPAKS[@]} · Layered: ${#RPM_OSTREE[@]}"
cat <<'NOTES'

NOTES:
  • The Hyprland desktop (hyprland, waybar, swayosd, dunst, hyprpaper, hyprlock,
    hypridle, jankyborders-equivalent) is best provisioned through Bazzite's own
    image or `ujust` recipes, not ad-hoc layering. Install those, then re-run
    ./scripts/stow.sh to drop in your configs.
  • After this, run `exec zsh` to reload your shell.
NOTES

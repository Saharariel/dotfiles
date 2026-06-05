#!/bin/bash
set -e

# ============================================
# PACKAGE DEFINITIONS
# ============================================

# CLI Tools & Utilities
CLI_TOOLS=(
  git
  lazygit
  wget
  htop
  neovim
  tmux
  fzf
  zoxide
  stow
)

# Shell Enhancements
SHELL_TOOLS=(
  powerlevel10k
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Window Management & UI
WM_TOOLS=(
  sketchybar
  borders
)

# GUI Applications (Casks)
CASKS=(
  aerospace
)

# Required Taps
TAPS=(
  FelixKratz/formulae
  nikitabobko/tap
)

# ============================================
# HELPER FUNCTIONS
# ============================================

print_header() {
  echo ""
  echo "========================================="
  echo "$1"
  echo "========================================="
}

print_success() {
  echo "✓ $1"
}

print_info() {
  echo "→ $1"
}

print_skip() {
  echo "⊘ $1 (already installed)"
}

# ============================================
# MAIN SCRIPT
# ============================================

print_header "macOS Development Environment Setup"

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "❌ ERROR: Homebrew not found!"
  echo "Install from: https://brew.sh"
  exit 1
fi

print_success "Homebrew found: $(brew --version | head -n1)"

# Add taps
print_header "Adding Homebrew Taps"
for tap in "${TAPS[@]}"; do
  if brew tap | grep -q "^$tap\$"; then
    print_skip "$tap"
  else
    print_info "Adding tap: $tap"
    brew tap "$tap"
  fi
done

# Update Homebrew
print_header "Updating Homebrew"
print_info "Running brew update..."
brew update

# Install CLI Tools
print_header "Installing CLI Tools & Utilities"
for package in "${CLI_TOOLS[@]}"; do
  if brew list --formula "$package" &>/dev/null; then
    print_skip "$package"
  else
    print_info "Installing $package..."
    brew install "$package"
    print_success "$package installed"
  fi
done

# Install Shell Tools
print_header "Installing Shell Enhancements"
for package in "${SHELL_TOOLS[@]}"; do
  if brew list --formula "$package" &>/dev/null; then
    print_skip "$package"
  else
    print_info "Installing $package..."
    brew install "$package"
    print_success "$package installed"
  fi
done

# Install Window Management Tools
print_header "Installing Window Management & UI Tools"
for package in "${WM_TOOLS[@]}"; do
  if brew list --formula "$package" &>/dev/null; then
    print_skip "$package"
  else
    print_info "Installing $package..."
    brew install "$package"
    print_success "$package installed"
  fi
done

# Install Casks
print_header "Installing GUI Applications (Casks)"
for cask in "${CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    print_skip "$cask"
  else
    print_info "Installing $cask..."
    brew install --cask "$cask"
    print_success "$cask installed"
  fi
done

# Run brew doctor
print_header "Running Brew Doctor"
if brew doctor; then
  print_success "Brew doctor passed!"
else
  echo "⚠ Brew doctor found some issues (non-critical)"
fi

# Summary
print_header "Installation Complete!"
echo "📦 Installed packages:"
echo "   • CLI Tools: ${#CLI_TOOLS[@]} packages"
echo "   • Shell Tools: ${#SHELL_TOOLS[@]} packages"
echo "   • WM/UI Tools: ${#WM_TOOLS[@]} packages"
echo "   • Applications: ${#CASKS[@]} casks"
echo ""
echo "🎉 All done! Your macOS development environment is ready."
echo ""

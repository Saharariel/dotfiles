#!/usr/bin/env bash
# Symlink dotfile packages into $HOME using GNU stow.
# Shared packages are combined with an explicit machine profile.
set -euo pipefail

# Repo root is the parent of this script's directory.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES"

PROFILE=""
while (($#)); do
  case "$1" in
    --profile) [[ $# -ge 2 ]] || { echo "Missing profile name" >&2; exit 2; }; PROFILE="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  case "$(uname -s)" in
    Darwin) PROFILE=macos-work ;;
    Linux) PROFILE=bazzite-hyprland ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
  esac
fi

case "$PROFILE" in
  macos-work) DESKTOP=(aerospace sketchybar jankyborders) ;;
  bazzite-hyprland) DESKTOP=(hyprland waybar swayosd dunst) ;;
  devcontainer) DESKTOP=() ;;
  *) echo "Unsupported profile: $PROFILE" >&2; exit 2 ;;
esac

if ! command -v stow &>/dev/null; then
  echo "❌ stow not found. Install it first (run packages-*.sh)." >&2
  exit 1
fi

# Cross-platform configs (terminals, editor, shell, prompt).
SHARED=(zsh nvim tmux p10k ghostty kitty herdr)

# Shell + editor only — for headless dev containers (no terminal emulator,
# no desktop). Skips ghostty/kitty since the terminal runs on the host.
CONTAINER=(zsh nvim tmux p10k)

# Treat Debian/Ubuntu as a dev-container target: shell+editor configs only.
case "$PROFILE" in
  devcontainer) PACKAGES=("${CONTAINER[@]}") ;;
  *) PACKAGES=("${SHARED[@]}" "${DESKTOP[@]}") ;;
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

echo "→ Profile: $PROFILE"
echo "→ Stowing: ${PACKAGES[*]}"
# --restow cleanly re-links (handles renamed/removed files); adopt is intentionally
# NOT used so existing real files are reported as conflicts instead of overwritten.
stow -v --restow --target="$HOME" "${PACKAGES[@]}"

# claude gets per-file links (--no-folding) so stow never turns ~/.claude itself
# into a repo symlink - Claude Code writes history/sessions there. Skipped in
# dev containers, where ~/.claude is often bind-mounted from the host.
if [[ "$PROFILE" != devcontainer ]]; then
  echo "→ Stowing (no folding): claude"
  stow -v --restow --no-folding --target="$HOME" claude
fi
echo "✓ Done."

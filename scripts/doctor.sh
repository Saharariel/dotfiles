#!/usr/bin/env bash
# Validate the selected profile without changing the system.
set -euo pipefail

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
  macos-work) REQUIRED=(zsh git stow nvim tmux brew) ;;
  bazzite-hyprland) REQUIRED=(zsh git stow nvim tmux brew hyprctl waybar) ;;
  devcontainer) REQUIRED=(zsh git stow nvim tmux fzf) ;;
  *) echo "Unsupported profile: $PROFILE" >&2; exit 2 ;;
esac

failures=0
printf 'Checking profile: %s\n' "$PROFILE"
for command_name in "${REQUIRED[@]}"; do
  if command -v "$command_name" >/dev/null 2>&1; then
    printf '  [ok]   %s\n' "$command_name"
  else
    printf '  [miss] %s\n' "$command_name"
    ((failures+=1))
  fi
done

if [[ "$PROFILE" == bazzite-hyprland ]]; then
  for config in hyprland waybar swayosd dunst; do
    if [[ -e "$HOME/.config/$config" ]]; then
      printf '  [ok]   ~/.config/%s\n' "$config"
    else
      printf '  [miss] ~/.config/%s\n' "$config"
      ((failures+=1))
    fi
  done
fi

if [[ -e "$HOME/.p10k.zsh" ]]; then
  printf '  [ok]   ~/.p10k.zsh\n'
else
  printf '  [warn] ~/.p10k.zsh is not linked\n'
fi

if ((failures)); then
  printf '\nDoctor found %d missing requirement(s).\n' "$failures" >&2
  exit 1
fi
printf '\nDoctor passed.\n'

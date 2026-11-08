# dotfiles

My configs and machine bootstrap for three setups, managed with
[GNU Stow](https://www.gnu.org/software/stow/): each top-level directory is a
*package* whose contents mirror `$HOME`, and stow symlinks them into place.

| Profile | Machine | OS layer |
|---|---|---|
| `bazzite-hyprland` | Desktop PC | [Bazzite](https://bazzite.gg) with Hyprland, from my own image [`ghcr.io/saharariel/bazzite-hyprland`](https://github.com/Saharariel/bazzite-hyprland) |
| `macos-work` | Work Mac | macOS, AeroSpace + SketchyBar + JankyBorders |
| `devcontainer` | Debian/Ubuntu containers | Shell and editor only |

## Quick start

```bash
git clone https://github.com/Saharariel/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh                 # profile is detected from the OS
./install.sh --profile macos-work --dry-run   # pick one explicitly, change nothing
exec zsh
```

`install.sh` runs three steps for the selected profile:

1. `scripts/packages-<os>.sh` installs packages
2. `scripts/stow.sh` links the configs into `$HOME`
3. `scripts/doctor.sh` checks the result without changing anything

`scripts/dotfiles` is a small interactive menu over the same commands
(install, link, doctor, update).

## Layout

| Package | What it configures | Linked on |
|---|---|---|
| `zsh` | `.zshrc` plus `.zshrc.darwin` / `.zshrc.linux` per-OS fragments | all |
| `nvim` | Neovim (`~/.config/nvim`) | all |
| `tmux` | `.tmux.conf` | all |
| `p10k` | Powerlevel10k prompt | all |
| `kitty`, `ghostty` | Terminals | macOS, Bazzite |
| `herdr` | herdr config | macOS, Bazzite |
| `claude` | Claude Code `CLAUDE.md` and ccstatusline (linked per file) | macOS, Bazzite |
| `hyprland` | `hyprland.lua`, hypridle, hyprlock, hyprpaper | Bazzite |
| `waybar`, `swayosd`, `dunst` | Bar, OSD, notifications | Bazzite |
| `dbus-overrides` | Session D-Bus overrides (linked per file) | Bazzite |
| `aerospace`, `sketchybar`, `jankyborders` | macOS tiling and bar | macOS |
| `bash`, `nvim.old` | Kept for reference, not linked | none |

Not packages: `packages/` (package manifests), `scripts/` (repo tooling, run in
place), `install.sh`.

Stow never overwrites real files: if a target already exists and is not a
link, it reports a conflict. The one exception is the devcontainer profile,
which moves an existing `.zshrc` / `.bashrc` to `*.pre-stow` first, since
container base images ship their own.

## Bazzite desktop

The desktop is split into layers, each with one source of truth:

| Layer | Source |
|---|---|
| OS + Hyprland stack (hyprland, uwsm, waybar, swayosd, dunst, kitty, ...) | Image repo [`Saharariel/bazzite-hyprland`](https://github.com/Saharariel/bazzite-hyprland), rebuilt on GitHub whenever Bazzite updates |
| CLI tools, fonts, flatpak apps, npm and Go tools | [`packages/bazzite.Brewfile`](packages/bazzite.Brewfile), installed with `brew bundle` |
| Apps with their own installer | `scripts/packages-bazzite.sh` (Vicinae) |
| Configs | The stow packages above |

Nothing is layered with `rpm-ostree install`: system packages go into the
image repo, so a dependency conflict fails a CI build instead of `ujust update`.
`packages-bazzite.sh` warns if the machine is not booted from the image or has
layered packages.

Fresh install:

1. Install stock Bazzite DX
2. Switch to the image (one reboot), as described in the
   [image repo README](https://github.com/Saharariel/bazzite-hyprland#switching-a-machine-to-this-image)
3. `./install.sh` here
4. Restore the private items listed below

Refresh the Brewfile after installing or removing things:

```bash
brew bundle dump --force --no-vscode --file packages/bazzite.Brewfile
```

### Hyprland notes

- Hyprland 0.57+ reads only `hyprland.lua` (the old hyprlang `hyprland.conf` is gone).
  hypridle, hyprlock and hyprpaper still use `.conf`.
- `hyprctl dispatch` takes Lua now, for example
  `hyprctl dispatch 'hl.dsp.focus({ workspace = 2 })'`.
- Check the config of a running session with `hyprctl configerrors`.
- Don't delete the config file a running Hyprland has loaded: it writes a
  stub in its place and reloads it.

## macOS

`scripts/packages-macos.sh` installs Homebrew formulas, casks (AeroSpace) and
the window-manager stack (SketchyBar, JankyBorders).

## Dev containers

`scripts/packages-debian.sh` installs a small apt set and clones the zsh
plugins directly. Only `zsh`, `nvim`, `tmux` and `p10k` are linked: the
terminal and desktop run on the host, and `~/.claude` is often bind-mounted
from it.

## Private, not in this repo

These stay out of git on purpose; back them up separately:

- `~/.zshrc.local`: machine-local and secret shell config, sourced last by
  `.zshrc` (`*.local` files are gitignored)
- `~/.ssh`, `gh` login, other credentials
- The image signing key, `~/repos/bazzite-hyprland/cosign.key`

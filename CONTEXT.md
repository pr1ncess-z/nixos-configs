# NixOS Configs

A flake-managed NixOS configuration repo. Currently targets a gaming PC (`durian`); intended to grow into a multi-host setup spanning a gaming laptop and a MacBook (via nix-darwin).

## Language

**Host**:
A single physical or virtual machine managed by this repo's flake. Each host has an entry point under `hosts/<hostname>/`.
_Avoid_: Machine, system, profile, computer

**Module**:
A reusable, composable NixOS configuration in `modules/` imported by one or more hosts. A module is never a host.
_Avoid_: Profile, role, config

**Shared dotfile**:
A dotfile that applies identically across all hosts (e.g., `vimrc`, `gitconfig`). Lives in `modules/home/`.
_Avoid_: Common dotfile, global dotfile, universal config

**Host-specific dotfile**:
A dotfile that varies per machine (e.g., Hyprland monitor layout). Lives in `hosts/<name>/home/`.
_Avoid_: Local dotfile, per-machine config

**Data volume**:
The 500GB ext4 SSD mounted at `/mnt/data`. The disk-as-volume concept — a general data disk, distinct from any single content folder underneath it.
_Avoid_: Games drive, games SSD, data drive

**Games folder**:
The `games/` directory under the data volume (`/mnt/data/games/`). The Steam library target. A content folder, distinct from the data volume it lives under.
_Avoid_: Games mount, games drive, games partition

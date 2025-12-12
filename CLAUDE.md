# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal NixOS and home-manager configuration repository managing dotfiles and system configurations across multiple machines (Linux, macOS, WSL). The configuration uses Nix flakes for reproducible builds.

## Common Commands

### Initial Setup
```bash
# Clone upstream dependencies (oh-my-zsh, fast-syntax-highlighting)
./scripts/git-repos-upstreams-init.sh
```

### Applying Configurations
```bash
# Apply home-manager configuration (user-level packages and dotfiles)
./home-rebuild.sh

# Apply NixOS system configuration (system-level, requires sudo)
./nixos-rebuild.sh
```

Both rebuild scripts automatically:
1. Run `home-manager switch` or `nixos-rebuild switch` with the appropriate flake
2. Use `nvd diff` to show what changed between the old and new generations

### Updating Dependencies
```bash
# Update flake.lock with latest versions (equivalent to 'apt update')
nix flake update

# Update a specific input
nix flake update nixpkgs
```

### Testing Configuration Changes
```bash
# Test home-manager configuration without switching
home-manager build --flake ".#$(whoami)@$(hostname)"

# Test NixOS configuration without switching
sudo nixos-rebuild build --flake ".#$(hostname)"
```

### Formatting
```bash
# Format Nix files using alejandra
alejandra .
```

## Architecture

### Flake Structure

The `flake.nix` is the entry point defining:
- **Inputs**: nixpkgs (stable 25.05 + unstable), home-manager, tfenv overlay
- **Outputs**:
  - `nixosConfigurations`: System-level configs (luskan, oryndoll)
  - `homeConfigurations`: User-level configs for all machines

### Machine Definitions

Each machine is defined as `user@hostname` in flake.nix with `extraSpecialArgs`:
- `user`, `homeDir`: User information
- `gitUser`, `gitEmail`: Git configuration
- `hostName`: Machine identifier
- `homeManagerRepo`: Path to this repository
- `upstreamRepos`: Path to cloned upstream dependencies

**Private machines**: silverymoon, luskan, silverymoon-wsl, oryndoll (HTPC)
**Work machines**: menzoberranzan, GBMLV6QQLVV2J (macOS)

Note: oryndoll uses work user credentials (`wieslaw`) but private git credentials, as it's a personal HTPC box.

### Directory Structure

```
.
├── flake.nix                    # Main entry point
├── home-manager/
│   ├── common.nix              # Shared home-manager config (imports roles + machine-specific)
│   ├── machines/               # Per-machine home-manager configs
│   │   ├── silverymoon.nix
│   │   ├── luskan.nix
│   │   └── ...
│   └── roles/                  # Modular functionality configs
│       ├── git.nix             # Git configuration with aliases
│       ├── ssh.nix             # SSH configuration
│       ├── tmux.nix            # Tmux configuration
│       ├── neovim.nix          # Neovim configuration
│       ├── haskell.nix         # Haskell development tools
│       ├── latex.nix           # LaTeX tools
│       └── claude.nix          # Claude Code configuration
├── nixos/
│   ├── common.nix              # Shared NixOS config (locale, X11, base packages)
│   ├── machines/               # Per-machine NixOS configs
│   │   ├── luskan.nix
│   │   └── oryndoll.nix
│   ├── hardware/               # Hardware-specific configurations
│   └── roles/                  # NixOS role modules
├── config-files/               # Dotfiles symlinked by home-manager
│   ├── zshrc
│   ├── starship.toml
│   ├── alacritty.toml
│   └── upstreams-mu_repo
├── config-k9s/                 # K9s Kubernetes TUI configuration
├── config-nvchad/              # NvChad/Neovim configuration
└── scripts/                    # Utility scripts
```

### Configuration Pattern

**home-manager/common.nix**:
1. Extracts `specialArgs` (user, hostName, etc.) from flake
2. Imports machine-specific config from `machines/${hostName}.nix`
3. Imports role modules (git, ssh, tmux, neovim)
4. Defines shared packages (shell tools, kubernetes tools, cloud tools, python, etc.)
5. Uses `home.file` with `mkOutOfStoreSymlink` to link dotfiles from `config-files/` and upstream repos

**Machine-specific configs**:
- Import additional roles as needed (e.g., silverymoon.nix imports latex, haskell, claude)
- Add machine-specific packages
- Can define systemd user services

**Role modules**:
- Self-contained configurations for specific tools/purposes
- Use `specialArgs` for dynamic values (gitUser, gitEmail, etc.)
- Example: git.nix configures git with aliases and extraConfig

### File Linking Strategy

The configuration uses `config.lib.file.mkOutOfStoreSymlink` to create symlinks to files in this repository and `~/GIT_REPOS/Upstreams/`. This allows editing dotfiles directly without rebuilding:
- Shell configs: `.zshrc`, `.config/starship.toml`
- Application configs: alacritty, k9s
- Upstream repos: oh-my-zsh, fast-syntax-highlighting

### NixOS vs home-manager

- **NixOS** (`nixos/`): System-level configuration (hardware, networking, users, system services)
  - Only applies to Linux machines running NixOS
  - Uses `nixos-rebuild.sh`

- **home-manager** (`home-manager/`): User-level configuration (packages, dotfiles, user services)
  - Works on NixOS, other Linux distros, and macOS
  - Uses `home-rebuild.sh`

## Key Packages

Major categories defined in home-manager/common.nix:
- **Shell**: zsh (with oh-my-zsh), starship, fzf, ripgrep, zoxide
- **Kubernetes**: kubectl, k9s, helm, argocd, kubectx, stern
- **Cloud**: awscli2, terraform (via tfenv), terragrunt, ssm-session-manager-plugin
- **Development**: neovim (with nvchad), python 3.12 with ansible/pytest/requests, alejandra (Nix formatter)
- **Utilities**: difftastic, eza, fd, jq, yq, htop, ncdu, ranger

## Important Conventions

1. **State versions**: Keep `home.stateVersion` and `system.stateVersion` at "23.11" unless intentionally upgrading
2. **Hostname matching**: Machine configs are selected by hostname, so ensure flake.nix includes the current machine
3. **Impure builds**: `home-rebuild.sh` uses `--impure` flag for home-manager switch
4. **Experimental features**: Both scripts enable nix-command and flakes features

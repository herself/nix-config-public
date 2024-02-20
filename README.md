# nix-config

My dotfiles setup using Nix and home-manager.

### Installation
1. Clone this repo to `~/GIT_REPOS/Private`
1. Run `scripts/git-repos-upstreams-init.sh` to get the upstream repos we depend on
1. If using Nix: make sure to have `pkgs.home-manager` in `environment.systemPackages`
1. If using any other distro/mac: install `nixpkgs` and then `home-manager` standalone

### Running
All parameters, new machines, etc. are available in `flake.nix`.

#### Reconfigure NixOs
Run `./nixos-rebuild.sh`.

#### Reconfigure Home Manager
Run `./home-rebuild.sh`.

#### Update flake.lock with new repo data (think `apt update`)
Run `nix flake update`.

### Links

- https://github.com/Misterio77/nix-starter-configs - Config this one is based on
- https://fasterthanli.me/series/building-a-rust-service-with-nix/part-9 - Good Nix starter tutorial
- https://github.com/DeterminateSystems/nix-installer - Install Nix on macOS
- https://search.nixos.org/packages - Search Nix packages

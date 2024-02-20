{
  description = "My shiny nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TFEnv overlay
    tfenv.url = "github:cjlarose/tfenv-nix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    tfenv,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    nixosConfigurations = {
      luskan = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          hostName = "luskan";
        };
        # > Our main nixos configuration file <
        modules = [./nixos/common.nix];
      };
      oryndoll = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          hostName = "oryndoll";
        };
        # > Our main nixos configuration file <
        modules = [./nixos/common.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Use let to define some useful stuff for later
    homeConfigurations = let
      # Linux Nixos unstable channel 64 bit packages by default
      pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
      # Variables used later on for private PCs
      extraSpecialArgsPrivate = {
        user = "herself";
        homeDir = "/home/herself";
        gitUser = "Wiesław Herr";
        gitEmail = "wieslaw@example.com";
        homeManagerRepo = "/home/herself/GIT_REPOS/Private/nix-config";
        upstreamRepos = "/home/herself/GIT_REPOS/Upstreams";
      };
      # Variables used later on for work PCs
      extraSpecialArgsWork = {
        user = "wieslaw";
        homeDir = "/home/wieslaw";
        gitUser = "Wiesław Herr";
        gitEmail = "wieslaw.herr@evilcorp.com";
        homeManagerRepo = "/home/wieslaw/GIT_REPOS/Private/nix-config";
        upstreamRepos = "/home/wieslaw/GIT_REPOS/Upstreams";
      };
      # Main home-manager config file & list of overlays
      modules = [
        ./home-manager/common.nix
        {
          nixpkgs.overlays = [tfenv.overlays.default];
        }
      ];
      # Now the machine definitions using the above:
    in {
      "wieslaw@menzoberranzan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit inputs outputs;
          inherit (extraSpecialArgsWork) user homeDir gitUser gitEmail homeManagerRepo upstreamRepos;
          hostName = "menzoberranzan";
        };
      };
      "herself@luskan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit inputs outputs;
          inherit (extraSpecialArgsPrivate) user homeDir gitUser gitEmail homeManagerRepo upstreamRepos;
          hostName = "luskan";
        };
      };
      "herself@silverymoon" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit inputs outputs;
          inherit (extraSpecialArgsPrivate) user homeDir gitUser gitEmail homeManagerRepo upstreamRepos;
          hostName = "silverymoon";
        };
      };
      "wieslawherr@GBMLV6QQLVV2J" = home-manager.lib.homeManagerConfiguration {
        inherit modules;
        pkgs = nixpkgs-unstable.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs outputs;
          inherit (extraSpecialArgsWork) gitUser gitEmail;
          hostName = "GBMLV6QQLVV2J";
          user = "wieslawherr";
          homeDir = "/Users/wieslawherr";
          homeManagerRepo = "/Users/wieslawherr/GIT_REPOS/Private/nix-config";
          upstreamRepos = "/Users/wieslawherr/GIT_REPOS/Upstreams";
        };
      };
      "wieslaw@oryndoll" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit inputs outputs;
          inherit (extraSpecialArgsPrivate) gitUser gitEmail;
          inherit (extraSpecialArgsWork) user homeDir homeManagerRepo upstreamRepos;
          hostName = "oryndoll";
        };
      };
    };
  };
}

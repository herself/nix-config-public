{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) user hostName homeDir homeManagerRepo upstreamRepos gitUser gitEmail;
in {
  imports = [../roles/latex.nix ../roles/haskell.nix ../roles/claude.nix];

  home.packages = [
    pkgs.esphome
    pkgs.esptool
    pkgs.dump1090-fa
    pkgs.ollama-rocm
  ];

  systemd.user.services.nix-daemon-start = {
    Unit = {
      Description = "Start nix-daemon on restart";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "start-nix-daemon" ''
        #!/bin/bash

        sudo systemctl start nix-daemon.service
      ''}";
    };
  };

  # Hyprland configuration
  home.file = {
    ".config/hypr/hyprland.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/hyprland.conf";
  };
}

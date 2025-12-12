{
  lib,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) gitEmail;
in {
  home.packages = [
    pkgs.sqlite
    pkgs.mnamer
    pkgs.htop
  ];

  programs.tmux = {
    prefix = lib.mkForce "C-b";
    plugins = with pkgs; [
      # theme
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'dawn'
          set -g @rose_pine_directory 'on'
          set -g @rose_pine_show_current_program 'off'
          set -g @rose_pine_disable_active_window_menu 'off'
        '';
      }
    ];
  };

  systemd.user.services.docker-compose-start = {
    Unit = {
      Description = "Start docker-compose on restart";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "start-compose" ''
        #!/bin/bash

        docker compose -f /home/wieslaw/Seer-Stack/docker-compose.yaml up -d
      ''}";
    };
  };

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
}

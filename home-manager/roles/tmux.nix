{
  config,
  pkgs,
  specialArgs,
  ...
}: let
in {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    plugins = with pkgs; [
      # window names that make sense
      {
        plugin =
          pkgs.tmuxPlugins.mkTmuxPlugin
          {
            pluginName = "tmux-window-name";
            version = "master";
            src = pkgs.fetchFromGitHub {
              owner = "ofirgall";
              repo = "tmux-window-name";
              rev = "640003d2fe53ef3ddc08417063a15cc909757f76";
              sha256 = "sha256-V70zvvighDkBfuqjWYzC/61/+GkeIiqaOOaY5Ls25yI=";
            };
          };

        extraConfig = ''
          set -g @tmux_window_name_use_tilde "True"
          set -g @tmux_window_dir_programs "['nvim', 'vim', 'vi', 'git']"
          set -g @tmux_window_name_substitute_sets "[('.*?/.nix-profile/bin/(.+)', '\\g<1>'), ('m --cmd lua.*', 'm')]"
        '';
      }
      # prefix-u for opening files
      {
        plugin =
          pkgs.tmuxPlugins.mkTmuxPlugin
          {
            pluginName = "tmux-super-fingers";
            version = "unstable-2023-01-06";
            src = pkgs.fetchFromGitHub {
              owner = "artemave";
              repo = "tmux_super_fingers";
              rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
              sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
            };
          };

        extraConfig = "set -g @super-fingers-key u";
      }
      # theme
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'moon'
          set -g @rose_pine_directory 'on'
          set -g @rose_pine_show_current_program 'off'
          set -g @rose_pine_disable_active_window_menu 'off'
        '';
      }
      # better mouse management
      tmuxPlugins.better-mouse-mode
      # useful navigation shortcuts
      tmuxPlugins.pain-control
    ];
    extraConfig = ''
      bind-key C-a last-window
    '';
  };
}

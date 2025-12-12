{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  # Pin tmux to 3.5 for compatibility with tmux-fingers
  tmux35-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/b5b2fecd0cadd82ef107c9583018f381ae70f222.tar.gz";
    sha256 = "0bj1mjz2m4m5ns7c0cxxvraw0rc84cd172pv6vyqrgiw7ld339lk";
  }) {
    system = pkgs.system;
  };
in {
  programs.tmux = {
    enable = true;
    package = tmux35-pkgs.tmux;
    baseIndex = 1;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    terminal = "tmux-256color";

    # turn off sensible which fucks up login shells on macOS
    sensibleOnTop = false;

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
          set -g @tmux_window_dir_programs "['git']"
          set -g @tmux_window_name_substitute_sets "[('/nix/store/[^/]+-([^/]+)/bin/(.+)', '\\g<2>'), ('.*?/.nix-profile/bin/(.+)', '\\g<1>'), ('m --cmd lua.*', 'm')]"
        '';
      }
      # prefix-u for opening files
      {
        plugin = tmuxPlugins.fingers;
        extraConfig = ''
          set -g @fingers-main-action ':open:'
          set -g @fingers-key 'u'
          set -g @fingers-backdrop-style 'fg=colour242'
          set -g @fingers-highlight-style 'fg=colour11'
          set -g @fingers-hint-style 'fg=colour12,bold'
          set -g @fingers-hint-position 'left'
          set -g @fingers-keyboard-layout 'qwerty-right-hand'
        '';
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

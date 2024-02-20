{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  # let's take the variables from the flake and put them in main scope
  inherit (specialArgs) user hostName homeDir homeManagerRepo upstreamRepos gitUser gitEmail;
in {
  news.display = "silent";

  # import per-machine config
  imports = [
    ./machines/${hostName}.nix
    ./roles/git.nix
    ./roles/tmux.nix
    ./roles/neovim.nix
  ];

  home.username = user;
  home.homeDirectory = homeDir;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # shell stuff
    pkgs.starship
    pkgs.fzf
    pkgs.zoxide
    pkgs.fortune-kind
    pkgs.ripgrep
    pkgs.vivid
    pkgs.htop

    # utils
    pkgs.eza
    pkgs.jq
    pkgs.fd
    pkgs.git-secrets
    pkgs.git-filter-repo
    pkgs.nix-search-cli
    pkgs.nix-diff
    pkgs.nvd
    pkgs.mu-repo
    pkgs.difftastic

    # kubernetes stuff
    pkgs.kubectl
    pkgs.k9s
    pkgs.kubectx
    pkgs.stern
    pkgs.yor
    pkgs.kubernetes-helm
    pkgs.argocd

    # cloud stuff
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
    pkgs.tfenv
    pkgs.terragrunt

    # lsp stuff
    pkgs.terraform-ls
    pkgs.nixd

    # others
    pkgs.postgresql_14
    pkgs.ffmpeg
    pkgs.alejandra

    # python 3.13 and packages
    (pkgs.python311.withPackages (p:
      with p; [
        pip
        ipython
        virtualenv
        requests
        # openai
        poetry-core
        python-lsp-server
        libtmux
        python-dateutil
      ]))

    # fonts
    (
      pkgs.nerdfonts.override {
        fonts = ["Lilex"];
      }
    )

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager can also manage your environment variables through
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    # locale stuff
    LANG = "en_GB.UTF-8";
    LC_COLLATE = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    LC_MESSAGES = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LANGUAGE = "en_GB:en";
    # k9s workarounds
    K9S_CONFIG_DIR = "${homeDir}/.config/k9s";
  };

  # Manage font installs as well
  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Mostly file linking magic
  home.file = {
    # Upstream repos for mu-repo
    "${upstreamRepos}/.mu_repo".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/upstreams-mu_repo";

    # Shell
    ".zshrc".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/zshrc";
    ".config/starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/starship.toml";
    ".oh-my-zsh".source =
      config.lib.file.mkOutOfStoreSymlink "${upstreamRepos}/oh-my-zsh";
    "${upstreamRepos}/oh-my-zsh/custom/plugins/fast-syntax-highlighting".source =
      config.lib.file.mkOutOfStoreSymlink "${upstreamRepos}/fast-syntax-highlighting";

    # Alacritty
    ".config/alacritty/alacritty.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/alacritty.toml";

    # K9s
    ".config/k9s/config.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-k9s/config.yaml";
    ".config/k9s/hotkeys.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-k9s/hotkeys.yaml";
    ".config/k9s/skins/rose-pine.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-k9s/skins/rose-pine.yaml";
    ".config/k9s/views.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-k9s/views.yaml";
  };
}

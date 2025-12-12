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
    ./roles/ssh.nix
    ./roles/tmux.nix
    ./roles/neovim.nix
  ];

  # Allow unfree packages (needed for claude-code and others)
  nixpkgs.config.allowUnfree = true;

  home.username = user;
  home.homeDirectory = homeDir;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Make home-manager manage nix packages
  nix.package = pkgs.nix;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # Make home-manager manage nix packages, part 2
    config.nix.package

    # shell stuff
    pkgs.fortune-kind
    pkgs.fzf
    pkgs.htop
    pkgs.ripgrep
    pkgs.starship
    pkgs.vivid
    pkgs.zoxide
    pkgs.bash-language-server

    # utils
    pkgs.difftastic
    pkgs.dust
    pkgs.eza
    pkgs.fd
    pkgs.git-filter-repo
    pkgs.git-secrets
    # pkgs.ipcalc
    pkgs.jq
    pkgs.mu-repo
    pkgs.ncdu
    pkgs.nix-diff
    pkgs.nix-search-cli
    pkgs.nvd
    pkgs.poppler-utils
    pkgs.pwgen
    pkgs.ranger
    pkgs.shellcheck
    pkgs.tig
    pkgs.yq-go

    # llm
    pkgs.code2prompt
    (pkgs.llm.withPlugins {
      llm-ollama = true;
    })

    # kubernetes stuff
    pkgs.argocd
    pkgs.helmfile
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubernetes-helm
    pkgs.stern
    pkgs.yor

    # cloud stuff
    pkgs.aws-nuke
    pkgs.awscli2
    pkgs.backblaze-b2
    pkgs.ssm-session-manager-plugin
    pkgs.terragrunt
    pkgs.tfenv

    # others
    pkgs.alejandra
    pkgs.ffmpeg
    pkgs.postgresql_14
    pkgs.libpq
    pkgs.libpq.pg_config
    # pkgs.neofetch
    pkgs.nmap
    pkgs.lua
    pkgs.graphviz-nox

    # fonts
    pkgs.nerd-fonts.lilex

    # python 3.13 and packages
    (pkgs.python312.withPackages (p:
      with p; [
        ipython
        ansible-core
        libtmux
        msgpack
        pip
        poetry-core
        pyserial
        pytest
        python-dateutil
        python-lsp-server
        requests
        uv
        virtualenv
      ]))

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

    # Nix config
    ".config/nix/nix.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/nix.conf";

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

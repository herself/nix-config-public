{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) user hostName homeDir homeManagerRepo upstreamRepos gitUser gitEmail;
in {
  imports = [../roles/latex.nix ../roles/copilot.nix];
  # imports = [../roles/latex.nix ../roles/haskell.nix];

  home.packages = [
    # GNU utils
    pkgs.gnused
    pkgs.wget
    pkgs.openssl
    pkgs.coreutils-prefixed

    # container runtimes
    # bye bye colima, you're great but $workplace bought Orbstack
    # pkgs.colima
    # pkgs.docker

    # vim baby!
    pkgs.neovide

    pkgs.gifsicle

    # work work
    pkgs.redis
    pkgs.ollama
  ];

  home.sessionVariables = {
    # tfenv hack to download for arm64
    TFENV_ARCH = "arm64";
    # old Terraform needs this
    KUBE_CONFIG_PATH = "${homeDir}/.kube/config";
  };

  home.file = {
    # Mac utils
    ".config/skhd/skhdrc".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/skhdrc";

    # Scripts
    "bin/scratchpad_spotify.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/scripts/macos/scratchpad_spotify.sh";

    ".config/aerospace/aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/aerospace.toml";
  };
}

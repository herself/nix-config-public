{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) user hostName homeDir homeManagerRepo upstreamRepos gitUser gitEmail;
in {
  home.packages = [
    # GNU utils
    pkgs.gnused

    # container runtimes
    pkgs.colima
    pkgs.docker

    # vim baby!
    pkgs.neovide
  ];

  home.sessionVariables = {
    TFENV_ARCH = "arm64";
  };

  home.file = {
    # Mac utils
    ".config/skhd/skhdrc".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/skhdrc";

    ".config/aerospace/aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/aerospace.toml";
  };
}

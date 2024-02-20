{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) upstreamRepos homeManagerRepo gitUser gitEmail;
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # NvChad prereqs
      ripgrep
      gcc
    ];
  };

  home.file = {
    # Upstream repos for mu-repo
    "${upstreamRepos}/.mu_repo".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/upstreams-mu_repo";

    # NvChad
    "${upstreamRepos}/nvchad/lua/custom".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-nvchad";
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${upstreamRepos}/nvchad";
  };
}

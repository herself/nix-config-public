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

  home.packages = [
    pkgs.terraform-ls
    pkgs.nixd

    pkgs.yaml-language-server
    pkgs.helm-ls
    # imported by haskell.nix for version compat
    # pkgs.haskell-language-server
    # pkgs.ormolu

    pkgs.bash-language-server
    pkgs.vscode-langservers-extracted

    pkgs.lua-language-server
    pkgs.luarocks
    pkgs.stylua
  ];

  home.file = {
    # Upstream repos for mu-repo
    "${upstreamRepos}/.mu_repo".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-files/upstreams-mu_repo";

    # NvChad
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-nvchad";
  };
}

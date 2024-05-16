{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) user hostName homeDir homeManagerRepo upstreamRepos gitUser gitEmail;
in {
  imports = [../roles/latex.nix];

  home.packages = [
    # GNU utils
    pkgs.rtorrent
  ];
}

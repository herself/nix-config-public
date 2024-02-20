{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) user hostName homeDir homeManagerRepo upstreamRepos gitUser gitEmail;
in {
  home.packages = [
    pkgs.sqlite
    pkgs.htop
  ];
}

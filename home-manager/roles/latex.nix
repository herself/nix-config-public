{
  config,
  pkgs,
  specialArgs,
  ...
}: let
in {
  home.packages = [
    # latex stuff go!
    pkgs.texliveFull
  ];
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/oryndoll.nix
    ../roles/media.nix
  ];

  # network
  networking.hostName = "oryndoll";
  networking.interfaces.enp1s0.ipv4.addresses = [
    {
      address = "192.168.1.32";
      prefixLength = 24;
    }
  ];

  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = ["192.168.1.1"];

  #users
  users.users.wieslaw = {
    isNormalUser = true;
    description = "Wiesław Herr";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  #hate sudo
  security.sudo.wheelNeedsPassword = false;
}

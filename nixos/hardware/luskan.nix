{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.initrd.availableKernelModules = ["ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  # filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/04f73fb0-7002-4843-b385-730f8fa7ad1b";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/65b3d259-03bb-4314-86df-98024aac884b";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/8c2096bf-2103-4c0c-a951-d84c729d07ec";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
}

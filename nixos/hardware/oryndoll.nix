{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # boot hax
  boot.initrd.availableKernelModules = ["ahci" "usbhid"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelParams = ["nomodeset"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.extraEntries = ''
    menuentry "Ubuntu" {
      search --set=ubuntu --fs-uuid 5ecc25a3-6bc5-4d13-80e8-9666c798fbd0
      configfile "($ubuntu)/grub/grub-ubuntu.cfg"
    }
  '';

  boot.loader.grub.extraInstallCommands = ''
    ''${pkgs.findutils}/bin/find /boot -not -path "/boot/efi/*" -type f -name '*.sig' -delete

    old_gpg_home=$GNUPGHOME

    export GNUPGHOME="$(mktemp -d)"

    ''${pkgs.gnupg}/bin/gpg --import ''${priv_key} > /dev/null 2>&1

    ''${pkgs.findutils}/bin/find /boot -not -path "/boot/efi/*" -type f -exec ''${pkgs.gnupg}/bin/gpg --detach-sign "{}" \; > /dev/null 2>&1

    rm -rf $GNUPGHOME

    export GNUPGHOME=$old_gpg_home
  '';

  # filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8c0b0eca-a140-4a5e-bd71-15780b92a0c8";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/F44F-268C";
    fsType = "vfat";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5ecc25a3-6bc5-4d13-80e8-9666c798fbd0";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/af1167a6-39e8-4fb3-854c-e4523a7eb25b";
    fsType = "ext4";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/8d9f70b0-ac39-47b8-ae95-fe3c62b2728b";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/6d4b3f12-d4de-4643-9e1f-444bf16448b2";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

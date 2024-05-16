{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # boot hax
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "i915" ];
  boot.kernelModules = [ "kvm-intel" "i915" ];
  boot.extraModulePackages = [ ];
  boot.loader.timeout = 1;
  hardware.firmware = [ pkgs.linux-firmware ];

  boot.kernelPackages = pkgs.linuxPackages_6_7;

  #boot.kernelParams = ["nomodeset"];
  boot.kernelParams = [ 
    "i915.force_probe=46d1" 
    #"i915.enable_guc=2"
    "i915.enable_psr=0"
    "i915.guc_log_level=4"
  ];

  #boot.initrd.extraFiles."/lib/firmware/i915/tgl_guc_70.bin".source =
  #(
  #  pkgs.runCommand "copy-915" { } ''
  #      mkdir -p $out/lib/firmware/i915
  #      cp ${../custom-files/edid/edid.bin} $out/lib/firmware/tgl_guc_70.bin
  #    ''
  #);

  boot.loader.grub.useOSProber = false;
  boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WDS120G1G0A-00SS50_164842453802";
  boot.loader.grub.forceInstall = true;

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

  hardware.cpu.intel.updateMicrocode  = true;

  #nixpkgs.config.packageOverrides = pkgs: {
  #  intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  #};

  services.xserver.config = ''
    Section "Device"
      Identifier "Intel Graphics"
      Driver "intel"
      Option "DRI" "2"
    EndSection
  '';
  services.xserver.videoDrivers = [ "intel" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { 
    LIBVA_DRIVER_NAME = "iHD"; 
    MESA_GL_VERSION_OVERRIDE = "4.6";
  };
}

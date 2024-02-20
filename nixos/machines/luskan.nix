{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware/luskan.nix
  ];

  # network
  networking.hostName = "luskan"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable pipewire for sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #users
  users.users.herself = {
    isNormalUser = true;
    description = "Wiesław Herr";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
}

{
  config,
  pkgs,
  specialArgs,
  ...
}: {
  imports = [
    machines/${specialArgs.hostName}.nix
  ];

  # boot splash
  # boot.plymouth.enable = true;

  # locale
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LANGUAGE = "en_GB";
    LC_ALL = "en_GB.UTF-8";
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # the X11 windowing system
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.extraConfig = "logind-check-graphical=true";
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.xkb.layout = "pl";
  # console.keyMap = "pl2";

  # nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # programs
  environment.systemPackages = with pkgs; [
    vim
    git
    home-manager
  ];

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}

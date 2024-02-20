{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kodi
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    x11vnc
  ];
  networking.firewall.allowedTCPPorts = [5900];

  users.users.kodi = {
    isNormalUser = true;
    description = "Kodi daemon";
    shell = pkgs.zsh;
  };

  services.xserver.displayManager = {
    defaultSession = "xfce";
    startx.enable = true;
    autoLogin = {
      enable = true;
      user = "kodi";
    };
  };

  services.transmission = {
    enable = true;
    user = "kodi";
    group = "users";
    openFirewall = true;
    openRPCPort = true;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "192.168.1.*,10.0.0.1";
      download-dir = "/mnt/media/Torrent";
      incomplete-dir = "/mnt/media/Torrent/Incomplete";
    };
    credentialsFile = "/home/kodi/transmission_auth.json";
  };

  services.jellyfin = {
    enable = true;
    user = "kodi";
    group = "users";
    openFirewall = true;
  };
}

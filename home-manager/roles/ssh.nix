{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) gitUser gitEmail;
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          # Use post-quantum key exchange algorithms
          KexAlgorithms = "sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256";
        };
      };
      oryndoll = {
        hostname = "oryndoll.makhleb.net";
        user = "wieslaw";
      };

      skullport = {
        hostname = "skullport.makhleb.net";
        user = "herself";
      };

      evernight = {
        hostname = "evernight.makhleb.net";
        user = "herself";
      };

      silverymoon = {
        hostname = "silverymoon.makhleb.net";
        user = "herself";
      };

      github = {
        hostname = "github.com";
        user = "git";
        extraOptions = {
          ControlMaster = "yes";
          ControlPersist = "2h";
        };
      };

      gitlab = {
        hostname = "lab.evilcorp.com";
        extraOptions = {
          ControlMaster = "yes";
          ControlPersist = "2h";
        };
      };
    };
  };
}

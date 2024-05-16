{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) gitUser gitEmail;
in {
  home.packages = [
    pkgs.git-lfs
  ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    difftastic.enable = true;
    userName = gitUser;
    userEmail = gitEmail;
    aliases = {
      amend = "commit -a --amend";
      st = "status -s";
      ci = "commit -am";
      pull = "pull --no-edit";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
      co = "checkout";
    };
    extraConfig = {
      push = {
        default = "current";
      };
      merge = {
        tool = "vimdiff";
      };
      color = {
        ui = "auto";
      };
    };
  };
}

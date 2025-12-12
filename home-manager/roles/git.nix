{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) gitUser gitEmail homeManagerRepo;
in {
  home.packages = [
    pkgs.git-lfs
    pkgs.lazygit
  ];

  home.file = {
    # Lazygit
    ".config/lazygit/config.yml".source =
      config.lib.file.mkOutOfStoreSymlink "${homeManagerRepo}/config-lazygit/config.yml";
  };

  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = gitUser;
        email = gitEmail;
      };
      alias = {
        amend = "commit -a --amend";
        st = "status -s";
        ci = "commit -am";
        pull = "pull --no-edit";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
        co = "checkout";
      };
      push = {
        default = "current";
        autoSetupRemote = "true";
      };
      merge = {
        tool = "vimdiff";
      };
      color = {
        ui = "auto";
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };
}

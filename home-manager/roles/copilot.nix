{
  config,
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) upstreamRepos homeManagerRepo gitUser gitEmail homeDir;
in {
  # Note: pkgs.claude-code is automatically added by programs.claude-code.enable
  home.packages = [
    pkgs.mcp-nixos
    pkgs.github-copilot-cli
  ];

  programs.opencode = {
    enable = true;
  };

  # GitHub Copilot CLI configuration with MCP servers
  home.file.".config/github-copilot/hosts.json" = {
    text = builtins.toJSON {
      api.githubcopilot.com = {
        user = gitUser;
        oauth_token = "";
        git_protocol = "https";
      };
    };
  };

  # MCP servers configuration for GitHub Copilot CLI
  home.file.".config/github-copilot/mcp_servers.json" = {
    text = builtins.toJSON {
      mcpServers = {
        # NixOS server for Nix-specific operations
        nixos = {
          command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
          args = [];
          env = {};
        };
      };
    };
  };
}

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
  ];

  programs.claude-code = {
    enable = true;

    # MCP servers configuration
    mcpServers = {
      # NixOS server for Nix-specific operations
      nixos = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      };
    };
  };
}

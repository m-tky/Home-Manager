{ inputs, pkgs, ... }:
{
  # GUI を必要としない、PC・WSL・nix-on-droid で共用する開発ツール。
  home.packages = [
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

{ inputs, pkgs, ... }:
{
  # GUI を必要としない、PC・WSL・nix-on-droid で共用する開発ツール。
  home.packages = with pkgs; [
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    zsh-patina
    gh
    delta
    openssh
    rsync
    curl
    file
    shellcheck
    ripgrep
    jq
    yq-go
    tree
    unzip
    zip
  ];

  xdg.configFile = {
    "zsh-patina/nightfox.toml".source = ../../../assets/zsh-patina/nightfox.toml;
    "zsh-patina/config.toml".source = ../../../assets/zsh-patina/config.toml;
  };
}

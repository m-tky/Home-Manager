{ inputs, pkgs, ... }:
{
  # WSL は Windows 側のターミナル／GUI を使うため、Wayland や
  # Linux GUI アプリケーションを持ち込まず、CLI の開発環境だけを管理する。
  imports = [
    inputs.nixCats-nvim.homeModules.default
  ];

  home.packages = with pkgs; [
    curl
    wget
    git
    gh
    (writeShellScriptBin "nvim" ''
      exec ${inputs.nixCats-nvim.packages.${pkgs.stdenv.hostPlatform.system}.nixCats}/bin/nixCats "$@"
    '')
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default
    ripgrep
    fd
    fzf
    bat
    eza
    bottom
    lazygit
    yazi
    zellij
    zoxide
    starship
    direnv
    rclone
    zsh
    jq
    yq-go
    tree
    killall
    translate-shell
    unzip
    zip
    gnutar
    gnused
    gnugrep
    findutils
    pkg-config
    openssl
    uv
    rustc
    clippy
    rustfmt
    delta
    imagemagick
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # 既存の各 Linux 環境と同じ NixCats ベースの Neovim を提供する。
  nixCats = {
    enable = true;
    packageNames = [ "nixCats" ];
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
    };
    sessionPath = [ "$HOME/.local/bin" ];
  };
}

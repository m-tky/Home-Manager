{
  inputs,
  pkgs,
  ...
}:
{
  # WSL は Windows 側のターミナル／GUI を使うため、Wayland や
  # Linux GUI アプリケーションを持ち込まず、CLI の開発環境だけを管理する。
  imports = [
    inputs.nixCats-nvim.homeModules.default
    ../features/common/cli/config.nix
  ];

  home.packages = with pkgs; [
    gh
    (writeShellScriptBin "nvim" ''
      exec ${inputs.nixCats-nvim.packages.${pkgs.stdenv.hostPlatform.system}.nixCats}/bin/nixCats "$@"
    '')
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default
    curl
    file
    openssh
    rsync
    shellcheck
    ripgrep
    jq
    yq-go
    tree
    killall
    unzip
    zip
    findutils
    pkg-config
    delta
    imagemagick
  ];

  programs = {
    home-manager.enable = true;
  };

  # 既存の各 Linux 環境と同じ NixCats ベースの Neovim を提供する。
  nixCats = {
    enable = true;
    packageNames = [ "nixCats" ];
  };

  home = {
    sessionVariables = {
      VISUAL = "vim";
      GIT_EDITOR = "vim";
    };
  };
}

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
    ../features/common/cli/development-tools.nix
    ../features/common/cli/config.nix
  ];

  home.packages = with pkgs; [
    (writeShellScriptBin "nvim" ''
      exec ${inputs.nixCats-nvim.packages.${pkgs.stdenv.hostPlatform.system}.nixCats}/bin/nixCats "$@"
    '')
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    killall
    findutils
    pkg-config
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

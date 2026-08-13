{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # zsh のほかの初期化処理の後にテーマを有効化する。
  programs.zsh.initContent = lib.mkAfter ''
    eval "$( ${pkgs.zsh-patina}/bin/zsh-patina activate)"
  '';
}

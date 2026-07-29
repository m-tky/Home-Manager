{ inputs, lib, pkgs, ... }:
{
  # zsh のほかの初期化処理の後にテーマを有効化する。
  programs.zsh.initContent = lib.mkAfter ''
    eval "$( ${inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/zsh-patina activate)"
  '';
}

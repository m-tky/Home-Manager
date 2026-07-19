{ inputs, pkgs, ... }:
{
  # GUI に依存しない共通ツール。
  home.packages = with pkgs; [
    # AI 開発支援
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Git・データ処理・ドキュメント
    gh
    jq
    tree
    tesseract
    delta
    unzip
  ];
}

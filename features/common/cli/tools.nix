{ inputs, pkgs, ... }:
{
  imports = [ ./development-tools.nix ];

  # GUI に依存しない共通ツール。
  home.packages = with pkgs; [
    # AI 開発支援
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    # Git・データ処理・ドキュメント
    tesseract
  ];
}

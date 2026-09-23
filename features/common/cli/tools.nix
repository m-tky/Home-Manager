{ pkgs, ... }:
{
  imports = [
    ./development-tools.nix
    ./llm-tools.nix
  ];

  # GUI に依存しない共通ツール。
  home.packages = with pkgs; [
    # Git・データ処理・ドキュメント
    tesseract
  ];
}

{ inputs, pkgs, ... }:
{
  # GUI に依存しない共通ツール。
  home.packages = with pkgs; [
    # 開発言語・AI 開発支援
    (python3.withPackages (ps: with ps; [ numpy ]))
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default
    typst
    rustc
    cargo
    clippy
    rustfmt

    # Git・データ処理・ドキュメント
    gh
    jq
    tree
    tesseract
    delta
    unzip
    python3Packages.jupytext
    imagemagick
  ];
}

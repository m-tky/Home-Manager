{ ... }:
{
  # デスクトップ／通常 Linux 向けの、CLI ツールと設定を含む入口。
  imports = [
    ./tools.nix
    ./config.nix
  ];
}

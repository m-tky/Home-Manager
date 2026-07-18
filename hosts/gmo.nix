{ ... }:
{
  # WSL 固有のホスト定義。ツール群は profiles/wsl.nix にまとめる。
  imports = [ ../profiles/wsl.nix ];
}

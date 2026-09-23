{ inputs, ... }:
{
  # GUI を必要としない、PC・WSL・nix-on-droid で共用する開発ツール。
  imports = [
    inputs.omp.homeManagerModules.default
  ];

  programs.omp.enable = true;

}

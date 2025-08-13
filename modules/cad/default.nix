{ pkgs, ... }:
{
  # packages for cad
  home.packages = with pkgs; [
    diylc
    freecad
  ];
}

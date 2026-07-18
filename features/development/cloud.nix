{ pkgs, ... }:
{
  # install terraform
  home.packages = with pkgs; [
    terraform
  ];
}

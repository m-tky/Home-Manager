{ pkgs, ... }:
{
  imports = [
    ./swayidle.nix
    ./niri.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    # ./hyprpanel.nix
    # ./waybar.nix
  ];
}

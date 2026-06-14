{ pkgs, ... }:
{
  imports = [
    ./swayidle.nix
    ./niri.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./wayland-conky.nix
    # ./hyprpanel.nix
    # ./waybar.nix
  ];
}

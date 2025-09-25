{ pkgs, ...}:
{
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    # ./hyprpanel.nix
    ./waybar.nix
    ./hyprpaper.nix
  ];
}

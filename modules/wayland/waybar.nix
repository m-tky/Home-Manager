{ pkgs, ... }:
{
  home.packages = with pkgs; [
    font-awesome
    workstyle
  ];

  programs.waybar = {
    enable = true;
  };

  home.file = {
    ".local/bin/shutdown.sh".source = ../../config/waybar/shutdown.sh;
  };
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    workstyle
    nvd
  ];

  programs.waybar = {
    enable = true;
  };

  home.file = {
    ".local/bin/update-checker".source = ./scripts/update-checker;
    ".local/bin/shutdown.sh".source = ./scripts/shutdown.sh;
  };
  xdg.configFile."waybar" = {
    source = ../../config/waybar;
    recursive = true;
  };
}

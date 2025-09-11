{ pkgs, ...}:
{
  home.packages = with pkgs; [
    workstyle
    nvd
  ];

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  xdg.configFile."waybar" = {
    source = ../../config/waybar;
    recursive = true;
  };

  home.file = {
    ".local/bin/update-checker".source = ./scripts/update-checker;
  };
}

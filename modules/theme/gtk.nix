{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    font = {
      package = pkgs.ibm-plex;
      size = 10;
      name = "IBM Plex Sans Regular";
    };
  };
  # install nwg-look
  home.packages = with pkgs; [
    nwg-look
  ];
}

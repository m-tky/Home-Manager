{ pkgs, ... }:
{
  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # theme = {
    #   name = "Catppuccin-GTK-Dark";
    #   package = pkgs.magnetic-catppuccin-gtk;
    # };
    font = {
      package = pkgs.ibm-plex;
      size = 10;
      name = "IBM Plex Sans Regular";
    };
  };
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/xsettings" = {
      antialiasing = "rgba";
      hinting = "full";
      rgba-order = "rgb";
    };
  };
  # install nwg-look
  home = {
    packages = with pkgs; [
      nwg-look
    ];
  };
  # xdg.configFile = {
  #   # ~/.config/gtk-3.0/gtk.css にリンクを張る
  #   "gtk-3.0/gtk.css".source = ./gtk/Adwaita-One-Dark/colors/gtk-dark.css;
  #
  #   # ~/.config/gtk-4.0/gtk.css にリンクを張る
  #   "gtk-4.0/gtk.css".source = ./gtk/Adwaita-One-Dark/colors/gtk-dark.css;
  # };
}

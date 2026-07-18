{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum
  ];
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
  # xdg.configFile = {
  #   "qt5ct/qt5ct.conf".source = ./qt5ct.conf;
  #   "qt6ct/qt6ct.conf".source = ./qt6ct.conf;
  #   "Kvantum" = {
  #     source = ./kvantum;
  #     recursive = true;
  #   };
  #   "kdeglobals".source = ./kdeglobals;
  # };
}

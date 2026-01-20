{
  config,
  lib,
  pkgs,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-skk
        libskk
        fcitx5-mozc
        fcitx5-gtk
        kdePackages.fcitx5-qt
        libsForQt5.fcitx5-qt
        # catppuccin-fcitx5
      ];
      waylandFrontend = true;
    };
  };
  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
    DefaultIMModule = "fcitx";
    NIXOS_OZONE_WL = "1";
  };
  home.file = {
    ".local/share/fcitx5/skk/dictionary_list".text = with pkgs; ''
      file=${libskk}/share/skk/SKK-JISYO.L,mode=readonly,type=file
    '';
  };
  xdg.configFile."fcitx5".source = lib.mkForce ../config/fcitx5;
  # xdg.configFile."fcitx5" = {
  #   source = ../config/fcitx5;
  #   recursive = true;
  # };
}

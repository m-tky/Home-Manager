{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.skk-mozc.homeManagerModules.default ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        # fcitx5-skk は skk-mozc に置き換え (どちらも skk.so を提供するので
        # 同居不可)。skk-mozc 側がアドオンを programs.fcitx5-skk-mozc.enable
        # 経由で自動追加するので、ここにはもう書かない。
        libskk
        fcitx5-mozc # Mozc を単独 IM として切り替えたい場合に残す
        fcitx5-gtk
        kdePackages.fcitx5-qt
        libsForQt5.fcitx5-qt
        # catppuccin-fcitx5
      ];
      waylandFrontend = true;
    };
  };

  programs.fcitx5-skk-mozc = {
    enable = true;
    mozc = {
      ipcTimeoutMs = 50;
      maxCandidates = 20;
    };
    debug = true; # ~/.cache/skk-mozc/log にログを書き出す
  };

  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
    DefaultIMModule = "fcitx";
    NIXOS_OZONE_WL = "1";
  };

  # SKK system dictionaries. skk-mozc reads this file the standard
  # fcitx5-skk way; the dictionary contents themselves are pure SKK.
  home.file.".local/share/fcitx5/skk/dictionary_list".text = with pkgs; ''
    file=${skkDictionaries.l}/share/skk/SKK-JISYO.L,mode=readonly,type=file
    file=${skkDictionaries.jinmei}/share/skk/SKK-JISYO.jinmei,mode=readonly,type=file
  '';

  # fcitx5 personal config (hotkeys, default IM, skk.conf etc.) sourced
  # from this repo's assets/fcitx5/. `recursive = true` symlinks
  # each file individually so other home-manager modules (skk-mozc,
  # input-method overlays, theming addons, …) can add their own files
  # under ~/.config/fcitx5/* without colliding with this directory.
  xdg.configFile."fcitx5" = {
    source = ../../assets/fcitx5;
    recursive = true;
  };
}

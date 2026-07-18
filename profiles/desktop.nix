{
  imports = [
    ../features/common/cli/default.nix
    ../features/development/editor.nix
    ../features/desktop/default.nix
    ../features/localization/fcitx5.nix
    ../features/theme/default.nix
    ../features/wayland/core.nix
  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = true;
}

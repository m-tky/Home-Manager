{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.home-manager.enable = true;
  systemd.user.startServices = true;
  imports = [
    ../modules/cli.nix
    ../modules/editor/default.nix
    ../modules/gui.nix
    ../modules/localization/fcitx5.nix
    ../modules/theme/default.nix
    ../modules/wayland/core.nix
    ../modules/wayland/wlogout/default.nix
    ../modules/wayland/hypr/default.nix
    ../modules/wayland/hypr/monitor/hyprland-monitor-mini.nix
    ../modules/systemd/mini-home-manager.nix
  ];
  home.packages = with pkgs; [
    pandoc
  ];
}

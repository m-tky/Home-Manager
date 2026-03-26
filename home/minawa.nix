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
    ../modules/wayland/niri/default.nix
  ];

  programs = {
    firefox.enable = true;
  };
  home.packages = with pkgs; [
    (pkgs.llama-cpp.override {
      cudaSupport = true;
    })
  ];
  xdg.enable = true;
}

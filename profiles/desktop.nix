{ inputs, pkgs, ... }:
{
  imports = [
    inputs.codex-desktop-linux.homeManagerModules.codex-desktop-linux
    ../features/common/cli/default.nix
    ../features/development/editor.nix
    ../features/desktop/default.nix
    ../features/localization/fcitx5.nix
    ../features/theme/default.nix
    ../features/wayland/core.nix
  ];

  programs.home-manager.enable = true;
  programs.codexDesktopLinux = {
    enable = true;
    cliPackage = inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
  systemd.user.startServices = true;
}

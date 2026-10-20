{ inputs, pkgs, ... }:
{
  imports = [
    inputs.meetily.homeManagerModules.default
    ../features/common/cli/default.nix
    ../features/development/editor.nix
    ../features/desktop/default.nix
    ../features/localization/fcitx5.nix
    ../features/theme/default.nix
    ../features/wayland/core.nix
  ];

  # Keep Meetily's tested nixpkgs pin; its ASR worker targets znver3 CPUs.
  # Models and credentials stay user-managed outside the Nix store.
  programs.meetily = {
    enable = true;
    package = inputs.meetily.packages.${pkgs.stdenv.hostPlatform.system}.meetily;
  };
  programs.home-manager.enable = true;
  systemd.user.startServices = true;
}

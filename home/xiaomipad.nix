{ pkgs, ... }:
{
  systemd.user.startServices = false;
  programs.home-manager.enable = true;
  services.ssh-agent.enable = true;
  programs.git.enable = true;
  home.packages = with pkgs; [
    ripgrep
    curl
    wget
    gnused
    gnugrep
    findutils
  ];
  imports = [
    ../modules/cli.nix
    ../modules/nvim-android/default.nix
  ];
}

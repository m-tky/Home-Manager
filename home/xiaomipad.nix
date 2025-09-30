{ inputs, pkgs, ... }:
{
  imports = [
    ../modules/cli.nix
    inputs.nixCats-nvim.homeModules.default
  ];
  nixCats = {
    enable = true;
    packageNames = [ "androidCats" ];
  };
  systemd.user.startServices = false;
  programs.home-manager.enable = true;
  services.ssh-agent.enable = true;
  programs.git.enable = true;
  home.packages = with pkgs; [
    openssh
    gdown
    ripgrep
    curl
    wget
    gnused
    gnugrep
    findutils
    unzip
  ];
}

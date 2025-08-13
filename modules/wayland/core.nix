# ~/dotfiles/linux/wm.nix
{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # inputs.quickshell.packages.x86_64-linux.default
    walker
    wlvncc
    nwg-displays
    pavucontrol
    wayvnc
    libsForQt5.xwaylandvideobridge
    wf-recorder
    wl-clipboard
    helvum
    nwg-drawer
    flameshot
    foot
    wdisplays
  ];
  services = {
    copyq.enable = true;
  };
  home.file.".config/foot" = {
    source = ../config/foot;
    recursive = true;
  };
  # home.file."sherlock" = {
  #   source = ../config/sherlock;
  #   recursive = true;
  # };
}

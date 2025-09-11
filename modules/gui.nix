# install obsidian and chromium with home-manager
{ config, pkgs, inputs, ... }:
let
  myObsidian = pkgs.symlinkJoin {
    name = "obsidian-with-flags";
    paths = [ pkgs.obsidian ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obsidian \
        --add-flags "--enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer,UseOzonePlatform" \
        --add-flags "--ozone-platform=wayland" \
        --add-flags "--wayland-text-input-version=3" \
        --add-flags "--enable-wayland-ime"
    '';
  };
in
{
  programs.chromium.enable = true;
  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
  home.packages = with pkgs; [
    zoom-us
    myObsidian
    inputs.zen-browser.packages.${system}.specific
    anki-bin
    spotify
    webcord
    slack
    freetube
    bitwarden-cli
    calibre
    inkscape
    mpv
    zathura
    qalculate-gtk
    bottles
    ffmpegthumbnailer
    android-file-transfer
    isoimagewriter
    nextcloud-client
    showmethekey
    cheese
    networkmanagerapplet
    mission-center
    kdePackages.kalgebra
    jellyfin-mpv-shim
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xournalpp
    vdhcoapp
    scrcpy

    (pkgs.makeDesktopItem {
      name = "Messenger";
      desktopName = "Messenger";
      exec = "${pkgs.chromium}/bin/chromium --enable-features=UseOzonePlatform --ozone-platform-hint=wayland --wayland-text-input-version=3 --enable-wayland-ime --app=https://messenger.com";
      icon = "fbmessenger";
      categories = [ "Network" "InstantMessaging" ];
    })
  ];
  # Enable the GUI applications to run in the home-manager environment
  xdg.enable = true;
  # Optional: Set up a desktop entry for Obsidian
}

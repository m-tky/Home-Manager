# install obsidian and chromium with home-manager
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
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
  mychromium = pkgs.symlinkJoin {
    name = "chrome-with-flags";
    paths = [ pkgs.google-chrome ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/google-chrome \
        --add-flags "--enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer,UseOzonePlatform" \
        --add-flags "--ozone-platform=wayland" \
        --add-flags "--wayland-text-input-version=3" \
        --add-flags "--enable-wayland-ime" \
        --add-flags "--disable-features=WaylandWpColorManagerV1"
    '';
  };
in
{
  programs = {
    firefox.enable = true;
    chromium = {
      enable = true;
      package = mychromium;
    };
  };
  services = {
    gnome-keyring.enable = true;
    syncthing = {
      enable = true;
      tray = {
        enable = true;
      };
    };
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
  home.packages = with pkgs; [
    inputs.hermes-agent.packages.${pkgs.system}.desktop
    element-desktop
    koreader
    czkawka
    baobab
    readest
    discord
    glib
    heroic
    zoom-us
    myObsidian
    anki-bin
    spotify
    slack
    bitwarden-cli
    calibre
    inkscape
    mpv
    zathura
    qalculate-gtk
    ffmpegthumbnailer
    android-file-transfer
    kdePackages.isoimagewriter
    showmethekey
    cheese
    networkmanagerapplet
    mission-center
    kdePackages.kalgebra
    thunar
    gvfs
    thunar-volman
    thunar-archive-plugin
    thunar-media-tags-plugin
    xournalpp
    scrcpy

    (pkgs.makeDesktopItem {
      name = "Messenger";
      desktopName = "Messenger";
      exec = "${pkgs.google-chrome}/bin/google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform-hint=wayland --wayland-text-input-version=3 --enable-wayland-ime --app=https://messenger.com";
      icon = "fbmessenger";
      categories = [
        "Network"
        "InstantMessaging"
      ];
    })
  ];
  # Preserve GUI-managed MIME defaults; register only SMB links.
  # Thunar: Ctrl+L, then smb://server/share (GVfs is enabled by NixOS).
  home.activation.thunarSmb = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.xdg-utils}/bin/xdg-mime default thunar.desktop x-scheme-handler/smb
  '';
  # Enable the GUI applications to run in the home-manager environment
  xdg = {
    enable = true;
    desktopEntries = {
      antigravity = {
        name = "Antigravity";
        genericName = "Text Editor";
        exec = "antigravity --remote-debugging-port=9222 %F";
        icon = "antigravity";
        comment = "Code Editing. Redefined.";
        categories = [
          "Utility"
          "TextEditor"
          "Development"
          "IDE"
        ];
        settings = {
          StartupWMClass = "Antigravity";
          Keywords = "vscode";
        };
        actions = {
          new-empty-window = {
            name = "New Empty Window";
            exec = "antigravity --new-window --remote-debugging-port=9222 %F";
            icon = "antigravity";
          };
        };
      };
    };
  };
  # Optional: Set up a desktop entry for Obsidian
  home.file = {
    ".config/zathura/zathurarc".source = ../../assets/zathura/zathurarc;
  };
}

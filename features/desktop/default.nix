# install obsidian and chromium with home-manager
{
  config,
  pkgs,
  inputs,
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
    koreader
    czkawka
    baobab
    readest
    discord
    glib
    heroic
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide
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

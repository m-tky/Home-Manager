{
  config,
  pkgs,
  inputs,
  ...
}:
let
  mychromium = pkgs.symlinkJoin {
    name = "chromium-with-flags";
    paths = [ pkgs.chromium ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/chromium \
        --add-flags "--enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer,UseOzonePlatform" \
        --add-flags "--ozone-platform=wayland" \
        --add-flags "--wayland-text-input-version=3" \
        --add-flags "--enable-wayland-ime" \
        --add-flags "--disable-features=WaylandWpColorManagerV1"
    '';
  };
in
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
    chromium = {
      enable = true;
      package = mychromium;
    };
  };
  home.packages = with pkgs; [
    (pkgs.llama-cpp.override {
      cudaSupport = true;
    })
  ];
  xdg.enable = true;
}

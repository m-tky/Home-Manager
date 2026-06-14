{ inputs, ... }:
{
  imports = [ inputs.wayland-conky.homeManagerModules.default ];

  programs.wayland-conky = {
    enable = true;
    # Prod over Tailscale; flip to http://localhost:8001 when iterating
    # on the backend locally. PATs are issued in-app under
    # Settings → API keys → "Create key", then pasted into
    # `wayland-conky-setup`.
    apiBaseUrl = "http://orangepi3b:8002";
    theme.variant = "nightfox";
  };
}

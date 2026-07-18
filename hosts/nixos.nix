{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../profiles/desktop.nix
    ../features/wayland/wlogout/default.nix
    ../features/wayland/hypr/default.nix
    ../features/wayland/hypr/monitor/m75q.nix
  ];
}

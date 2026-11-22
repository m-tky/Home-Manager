{ config, lib, pkgs, ... }:
let
  monitorConfig = lib.escapeShellArg "${config.xdg.configHome}/niri/monitor.kdl";
  initialConfig = ''
    // Initial layout only; edit and save future changes with nwg-displays.
    output "DP-1" {
        mode "3440x1440@100"
        position x=0 y=0
    }
    output "DP-2" {
        mode "1920x1080@60"
        position x=1520 y=1440
    }
  '';
in
{
  # Seed the old layout once, without overwriting GUI-managed settings on switch.
  home.activation.seedNiriMonitors = lib.hm.dag.entryAfter [ "niriMonitorConfig" ] ''
    if [ ! -s ${monitorConfig} ]; then
      run install -m 644 ${pkgs.writeText "initial-niri-monitors.kdl" initialConfig} ${monitorConfig}
    fi
  '';
}

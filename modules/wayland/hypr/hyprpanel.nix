{ pkgs, inputs, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    power-profiles-daemon
    jq
    vulnix
    pavucontrol
    brightnessctl
    btop
  ];
  programs.ags = {
    enable = true;
  };
  programs.hyprpanel = {
    enable = true;
    settings = {
      layout = {
        "bar.layouts" =
          let
            layout ={
              "left" = [
                "dashboard"
                "workspaces"
                "windowtitle"
                "updates"
                "storage"
              ];
              "middle" = [
                "media"
              ];
              "right" = [
                "cpu"
                "ram"
                "volume"
                # "network"
                "bluetooth"
                "systray"
                "clock"
                "notifications"
              ];
            };
          in
          {
            "*" = layout;
          };
      };
      bar.customModules.updates.pollingInterval = 1440000;
      theme.name = "tokyonight";
      theme.bar.floating = false;
      theme.bar.buttons.enableBorders = true;
      theme.bar.transparent = true;
      theme.font.size = "10px";
      menus.clock.time.military = true;
      menus.clock.time.hideSeconds = false;
      bar.clock.format = "%y/%m/%d  %H:%M";
      bar.media.show_active_only = true;
      bar.notifications.show_total = true;
      theme.bar.buttons.modules.ram.enableBorder = false;
      bar.launcher.autoDetectIcon = true;
      bar.battery.hideLabelWhenFull = true;
      menus.dashboard.controls.enabled = false;
      menus.dashboard.shortcuts.enabled = true;
      menus.clock.weather.enabled = false;
      # menus.dashboard.shortcuts.right.shortcut1.command = "${pkgs.gcolor3}/bin/gcolor3";
      menus.media.displayTime = true;
      menus.power.lowBatteryNotification = true;
      bar.customModules.updates.updateCommand = "vulnix -S --json | jq '[.[] | select((.cvssv3_basescore | to_entries | map(.value) | max) > 5)] | length'";
      bar.customModules.updates.icon.updated = "󰋼";
      bar.customModules.updates.icon.pending = "󰋼";
      bar.volume.rightClick = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      bar.volume.middleClick = "pavucontrol";
      bar.media.format = "{title}";
    };
  };
}

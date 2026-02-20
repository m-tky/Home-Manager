{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    ryubing
    arduino-ide
  ];
  services.ollama = {
    enable = true;
    environmentVariables = {
      OLLAMA_LLM_LIBRARY = "cpu";
      OLLAMA_HOST = "0.0.0.0:11434";
    };
  };
  systemd.user = {
    services."obsidianDocs-sync" = {
      Unit = {
        Description = "Sync Obsidian Docs to WebDAV";
      };
      Service = {
        Type = "Oneshot";
        ExecStart = "${config.home.homeDirectory}/.local/bin/rcloneObsidianDocuments.sh";
      };
    };
    timers."obsidianDocs-sync" = {
      Unit = {
        Description = "Timer to sync Obsidian Docs to WebDAV every 15 minutes";
      };
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "15min";
        AccuracySec = "1min";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
  programs.home-manager.enable = true;
  systemd.user.startServices = true;
  imports = [
    ../modules/cli.nix
    ../modules/editor/default.nix
    ../modules/gui.nix
    ../modules/localization/fcitx5.nix
    ../modules/theme/default.nix
    ../modules/wayland/core.nix
    ../modules/wayland/wlogout/default.nix
    ../modules/wayland/hypr/default.nix
    ../modules/wayland/hypr/monitor/hyprland-monitor-m75q.nix
    ../modules/systemd/m75q-home-manager.nix
    ../modules/cad/default.nix
    ../modules/cloud/default.nix
    ../modules/openclaw.nix
  ];
}

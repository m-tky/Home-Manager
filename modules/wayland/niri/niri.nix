{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.hyprlock.enable = true;
  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
    hyprpolkitagent.enable = true;
  };
  home.file = {
    ".local/bin/translate.sh".source = ./scripts/translate.sh;
    ".local/bin/select_language.sh".source = ./scripts/select_language.sh;
    ".local/bin/wayvnc_server.sh".source = ./scripts/wayvnc_server.sh;
    ".local/bin/wiki.sh".source = ./scripts/wiki.sh;
    ".local/bin/notevim.sh".source = ./scripts/notevim.sh;
    ".local/bin/raycast.sh".source = ./scripts/raycast.sh;
    ".local/bin/findfile.sh".source = ./scripts/findfile.sh;
    ".local/bin/findcontent.sh".source = ./scripts/findcontent.sh;
    ".local/bin/rcloneObsidianDocuments.sh".source = ./scripts/rcloneObsidianDocuments.sh;
    ".local/bin/toggle_blur.sh".source = ./scripts/toggle_blur.sh;
    ".local/bin/tm.sh".source = ./scripts/tm.sh;
  };
  programs.niri.settings = {
    # 入力設定
    input = {
      keyboard.numlock = true;
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
      warp-mouse-to-focus.mode = "center-xy";
      focus-follows-mouse.enable = true;
    };

    # 出力設定 (マルチモニター)
    # outputs = {
    #   "eDP-1" = {
    #     mode = "1920x1080@120.030";
    #     scale = 2.0;
    #     transform = "normal";
    #     position = {
    #       x = 1280;
    #       y = 0;
    #     };
    #   };
    #   "DP-1" = {
    #     mode = "3440x1440@100";
    #     scale = 1.0;
    #     transform = "normal";
    #     position = {
    #       x = 0;
    #       y = 0;
    #     };
    #   };
    #   "DP-2" = {
    #     mode = "1920x1080@60";
    #     scale = 1.0;
    #     transform = "normal";
    #     position = {
    #       x = 760;
    #       y = 1440;
    #     };
    #   };
    };

    # レイアウトと外観
    layout = {
      gaps = 6;
      center-focused-column = "never";
      preset-column-widths = [
        { proportion = 0.3; }
        { proportion = 0.4; }
        { proportion = 0.5; }
        { proportion = 0.6; }
        { proportion = 0.7; }
      ];
      default-column-width = {
        proportion = 0.5;
      };
      focus-ring = {
        width = 2;
        active-color = "#7fc8ff";
        inactive-color = "#505050";
      };
      border.off = true;
      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        color = "#0007";
      };
    };

    # 各種設定
    overview.zoom = 0.3;
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
      {
        command = [
          "swayidle"
          "-w"
          "timeout"
          "300"
          "niri msg action power-off-monitors"
          "resume"
          "niri msg action power-on-monitors"
        ];
      }
      { command = [ "udiskie" ]; }
      { command = [ "hypridle" ]; }
      { command = [ "hypridle" ]; }
      {
        command = [
          "nm-applet"
          "--sm-disable"
        ];
      }
      {
        command = [
          "wl-paste"
          "--type"
          "image"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "wl-paste"
          "--type"
          "text"
          "--watch"
          "cliphist"
          "store"
        ];
      }
    ];

    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    # ウィンドウ・レイヤールール
    window-rules = [
      {
        match.app-id = "^org\\.wezfurlong\\.wezterm$";
        default-column-width = { };
      }
      {
        match.app-id = "firefox$";
        match.title = "^Picture-in-Picture$";
        open-floating = true;
      }
      {
        geometry-corner-radius = 6;
        clip-to-geometry = true;
      }
      {
        match.app-id = "Matplotlib";
        open-floating = true;
      }
    ];

    layer-rules = [
      {
        match.namespace = "^noctalia-overview*";
        place-within-backdrop = true;
      }
    ];

    debug.honor-xdg-activation-with-invalid-serial = true;

    # キーバインド
    binds = with config.lib.niri.actions; {
      "Super+Shift+Slash".action = show-hotkey-overlay;

      "Mod+T".action = spawn "kitty";
      "Mod+D".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
      "Super+Alt+L".action = spawn "hyprlock";
      "Mod+B".action = spawn "firefox";
      "Mod+Ctrl+Space".action = sh "$HOME/.local/bin/raycast.sh";

      "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
      "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
      "XF86AudioMute".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioMicMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

      "XF86AudioPlay".action = sh "playerctl play-pause";
      "XF86AudioStop".action = sh "playerctl stop";
      "XF86AudioPrev".action = sh "playerctl previous";
      "XF86AudioNext".action = sh "playerctl next";

      "XF86MonBrightnessUp".action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
      "XF86MonBrightnessDown".action = spawn "brightnessctl" "--class=backlight" "set" "10%-";

      "Mod+O".action = toggle-overview;
      "Mod+Q".action = close-window;

      "Mod+H".action = focus-column-left;
      "Mod+J".action = focus-window-down;
      "Mod+K".action = focus-window-up;
      "Mod+L".action = focus-column-right;

      "Mod+Ctrl+H".action = move-column-left;
      "Mod+Ctrl+J".action = move-window-down;
      "Mod+Ctrl+K".action = move-window-up;
      "Mod+Ctrl+L".action = move-column-right;

      "Mod+Home".action = focus-column-first;
      "Mod+End".action = focus-column-last;
      "Mod+Ctrl+Home".action = move-column-to-first;
      "Mod+Ctrl+End".action = move-column-to-last;

      "Mod+Shift+H".action = focus-monitor-left;
      "Mod+Shift+J".action = focus-monitor-down;
      "Mod+Shift+K".action = focus-monitor-up;
      "Mod+Shift+L".action = focus-monitor-right;

      "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

      "Mod+U".action = focus-workspace-down;
      "Mod+I".action = focus-workspace-up;
      "Mod+Ctrl+U".action = move-column-to-workspace-down;
      "Mod+Ctrl+I".action = move-column-to-workspace-up;

      "Mod+Shift+Page_Down".action = move-workspace-down;
      "Mod+Shift+Page_Up".action = move-workspace-up;
      "Mod+Shift+U".action = move-workspace-down;
      "Mod+Shift+I".action = move-workspace-up;

      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;
      "Mod+6".action = focus-workspace 6;
      "Mod+7".action = focus-workspace 7;
      "Mod+8".action = focus-workspace 8;
      "Mod+9".action = focus-workspace 9;

      "Mod+Shift+1".action = move-column-to-workspace 1;
      "Mod+Shift+2".action = move-column-to-workspace 2;
      "Mod+Shift+3".action = move-column-to-workspace 3;
      "Mod+Shift+4".action = move-column-to-workspace 4;
      "Mod+Shift+5".action = move-column-to-workspace 5;
      "Mod+Shift+6".action = move-column-to-workspace 6;
      "Mod+Shift+7".action = move-column-to-workspace 7;
      "Mod+Shift+8".action = move-column-to-workspace 8;
      "Mod+Shift+9".action = move-column-to-workspace 9;

      "Mod+BracketLeft".action = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;
      "Mod+Comma".action = consume-window-into-column;
      "Mod+Period".action = expel-window-from-column;

      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = switch-preset-window-height;
      "Mod+Ctrl+R".action = reset-window-height;
      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+M".action = maximize-window-to-edges;
      "Mod+Ctrl+F".action = expand-column-to-available-width;
      "Mod+C".action = center-column;
      "Mod+Ctrl+C".action = center-visible-columns;

      "Mod+Minus".action = set-column-width "-5%";
      "Mod+Equal".action = set-column-width "+5%";
      "Mod+Shift+Minus".action = set-window-height "-5%";
      "Mod+Shift+Equal".action = set-window-height "+5%";

      "Mod+V".action = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
      "Mod+W".action = toggle-column-tabbed-display;

      "Mod+Ctrl+P".action = screenshot;
      "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
      "Mod+Shift+E".action = quit;
      "Ctrl+Alt+Delete".action = quit;
      "Mod+Shift+P".action = power-off-monitors;
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  focusOrOpenSteward = pkgs.writeShellApplication {
    name = "focus-or-open-steward";
    runtimeInputs = [
      pkgs.niri
      pkgs.jq
      config.programs.kitty.package
      pkgs.zellij
    ];
    text = ''
      window_id=$(niri msg --json windows | jq -r '[.[] | select(.app_id == "zellij-steward")][0].id // empty')
      if [[ -n "$window_id" ]]; then
        niri msg action focus-window --id "$window_id"
      else
        exec kitty --class zellij-steward -e zellij attach steward
      fi
    '';
  };
in
{
  # Use the NixOS-provided package for config validation; HM does not install it.
  programs.niri.package = pkgs.niri;

  # Validate the Nix-managed settings before adding the mutable monitor include.
  # The included file lives outside the store and is managed by nwg-displays.
  xdg.configFile.niri-config.source = lib.mkForce (
    pkgs.runCommand "niri-config-with-monitors.kdl"
      {
        configText = config.programs.niri.finalConfig;
        passAsFile = [ "configText" ];
      }
      ''
        ${lib.getExe config.programs.niri.package} validate -c "$configTextPath"
        cp "$configTextPath" "$out"
        printf '\ninclude "monitor.kdl"\n' >> "$out"
      ''
  );

  home.activation.niriMonitorConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p ${lib.escapeShellArg "${config.xdg.configHome}/niri"}
    if [ ! -e ${lib.escapeShellArg "${config.xdg.configHome}/niri/monitor.kdl"} ]; then
      run touch ${lib.escapeShellArg "${config.xdg.configHome}/niri/monitor.kdl"}
    fi
  '';
  home.file = {
    ".local/bin/translate.sh".source = ../scripts/translate.sh;
    ".local/bin/select_language.sh".source = ../scripts/select_language.sh;
    ".local/bin/wayvnc_server.sh".source = ../scripts/wayvnc_server.sh;
    ".local/bin/wiki.sh".source = ../scripts/wiki.sh;
    ".local/bin/notevim.sh".source = ../scripts/notevim.sh;
    ".local/bin/raycast.sh".source = ../scripts/raycast.sh;
    ".local/bin/findfile.sh".source = ../scripts/findfile.sh;
    ".local/bin/findcontent.sh".source = ../scripts/findcontent.sh;
  };
  programs.niri.settings = {
    prefer-no-csd = true;
    # 入力設定
    input = {
      keyboard.numlock = true;
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
      warp-mouse-to-focus = {
        enable = true;
        # mode = "center-xy";
      };
      # focus-follows-mouse.enable = true;
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
    # };

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
        proportion = 0.3;
      };
      focus-ring = {
        width = 2;
        active = {
          color = "#7fc8ff";
        };
        inactive = {
          color = "#505050";
        };
      };
      border.enable = false;

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
      { command = [ "udiskie" ]; }
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
      # 共通設定
      {
        draw-border-with-background = false;
        geometry-corner-radius = {
          top-left = 6.0;
          top-right = 6.0;
          bottom-left = 6.0;
          bottom-right = 6.0;
        };
        clip-to-geometry = true;
      }
      # kitty以外：非アクティブ時にDim、透過なし
      {
        matches = [
          { is-focused = false; }
        ];
        excludes = [
          { app-id = "^(kitty|zellij-steward)$"; }
        ];

        opacity = 0.90;

        shadow = {
          enable = true;
          draw-behind-window = true;
          softness = 0;
          spread = 0;
          offset = {
            x = 0;
            y = 0;
          };
          color = "#000000ff";
          inactive-color = "#000000ff";
        };
      }

      # kitty：非アクティブ時にDim、透過を維持
      {
        matches = [
          {
            app-id = "^(kitty|zellij-steward)$";
            is-focused = false;
          }
        ];

        opacity = 0.85;

        shadow = {
          enable = true;
          draw-behind-window = true;
          softness = 0;
          spread = 0;
          offset = {
            x = 0;
            y = 0;
          };
          color = "#00000050";
          inactive-color = "#00000050";
        };
      }

    ];
    layer-rules = [
      {
        matches = [
          {
            namespace = "^noctalia-backdrop";
          }
        ];
        place-within-backdrop = true;
      }
    ];

    # キーバインド
    binds = {
      "Super+Shift+Slash".action.show-hotkey-overlay = [ ];

      "Mod+T".hotkey-overlay.title = "Open terminal";
      "Mod+T".action.spawn = "kitty";
      "Mod+S".hotkey-overlay.title = "Open or focus Steward";
      "Mod+S".action.spawn = lib.getExe focusOrOpenSteward;
      "Mod+D".hotkey-overlay.title = "Open Noctalia launcher";
      "Mod+D".action.spawn = [
        "noctalia"
        "msg"
        "panel-toggle"
        "launcher"
      ];
      "Super+Alt+Escape".hotkey-overlay.title = "Lock screen (Noctalia)";
      "Super+Alt+Escape".action.spawn = [
        (lib.getExe config.programs.noctalia.package)
        "msg"
        "session"
        "lock"
      ];
      "Mod+P".hotkey-overlay.title = "Configure displays";
      "Mod+P".action.spawn = lib.getExe pkgs.nwg-displays;
      "Mod+B".hotkey-overlay.title = "Open browser";
      "Mod+B".action.spawn = "firefox";
      "Mod+Ctrl+Space".hotkey-overlay.title = "Open Noctalia launcher";
      "Mod+Ctrl+Space".action.spawn = [
        "sh"
        "-c"
        "$HOME/.local/bin/raycast.sh"
      ];

      "XF86AudioRaiseVolume".action.spawn = [
        "sh"
        "-c"
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"
      ];
      "XF86AudioLowerVolume".action.spawn = [
        "sh"
        "-c"
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"
      ];
      "XF86AudioMute".action.spawn = [
        "sh"
        "-c"
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ toggle"
      ];
      "XF86AudioMicMute".action.spawn = [
        "sh"
        "-c"
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      "XF86AudioPlay".action.spawn = [
        "playerctl"
        "play-pause"
      ];
      "XF86AudioStop".action.spawn = [
        "playerctl"
        "stop"
      ];
      "XF86AudioPrev".action.spawn = [
        "playerctl"
        "previous"
      ];
      "XF86AudioNext".action.spawn = [
        "playerctl"
        "next"
      ];

      "XF86MonBrightnessUp".action.spawn = [
        "brightnessctl"
        "--class=backlight"
        "set"
        "+10%"
      ];
      "XF86MonBrightnessDown".action.spawn = [
        "brightnessctl"
        "--class=backlight"
        "set"
        "10%-"
      ];

      "Mod+O".action.toggle-overview = [ ];
      "Mod+Q".action.close-window = [ ];

      "Mod+H".action.focus-column-left = [ ];
      "Mod+J".action.focus-window-down = [ ];
      "Mod+K".action.focus-window-up = [ ];
      "Mod+L".action.focus-column-right = [ ];

      "Mod+Ctrl+H".action.move-column-left = [ ];
      "Mod+Ctrl+J".action.move-window-down = [ ];
      "Mod+Ctrl+K".action.move-window-up = [ ];
      "Mod+Ctrl+L".action.move-column-right = [ ];

      "Mod+Home".action.focus-column-first = [ ];
      "Mod+End".action.focus-column-last = [ ];
      "Mod+Ctrl+Home".action.move-column-to-first = [ ];
      "Mod+Ctrl+End".action.move-column-to-last = [ ];

      "Mod+Shift+H".hotkey-overlay.title = "Focus monitor left";
      "Mod+Shift+H".action.focus-monitor-left = [ ];
      "Mod+Shift+J".hotkey-overlay.title = "Focus monitor down";
      "Mod+Shift+J".action.focus-monitor-down = [ ];
      "Mod+Shift+K".hotkey-overlay.title = "Focus monitor up";
      "Mod+Shift+K".action.focus-monitor-up = [ ];
      "Mod+Shift+L".hotkey-overlay.title = "Focus monitor right";
      "Mod+Shift+L".action.focus-monitor-right = [ ];

      "Mod+Alt+H".hotkey-overlay.title = "Move window to monitor left";
      "Mod+Alt+H".action.move-window-to-monitor-left = [ ];
      "Mod+Alt+J".hotkey-overlay.title = "Move window to monitor down";
      "Mod+Alt+J".action.move-window-to-monitor-down = [ ];
      "Mod+Alt+K".hotkey-overlay.title = "Move window to monitor up";
      "Mod+Alt+K".action.move-window-to-monitor-up = [ ];
      "Mod+Alt+L".hotkey-overlay.title = "Move window to monitor right";
      "Mod+Alt+L".action.move-window-to-monitor-right = [ ];

      "Mod+U".action.focus-workspace-down = [ ];
      "Mod+I".action.focus-workspace-up = [ ];
      "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
      "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];

      "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
      "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
      "Mod+Shift+U".action.move-workspace-down = [ ];
      "Mod+Shift+I".action.move-workspace-up = [ ];

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
      "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
      "Mod+Comma".action.consume-window-into-column = [ ];
      "Mod+Period".action.expel-window-from-column = [ ];

      "Mod+R".action.switch-preset-column-width = [ ];
      "Mod+Shift+R".action.switch-preset-window-height = [ ];
      "Mod+Ctrl+R".action.reset-window-height = [ ];
      "Mod+F".action.maximize-column = [ ];
      "Mod+Shift+F".action.fullscreen-window = [ ];
      "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];
      "Mod+C".action.center-column = [ ];
      "Mod+Ctrl+C".action.center-visible-columns = [ ];

      "Mod+Minus".action.set-column-width = "-5%";
      "Mod+Equal".action.set-column-width = "+5%";
      "Mod+Shift+Minus".action.set-window-height = "-5%";
      "Mod+Shift+Equal".action.set-window-height = "+5%";

      "Mod+V".action.toggle-window-floating = [ ];
      "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];
      "Mod+W".action.toggle-column-tabbed-display = [ ];

      "Mod+Ctrl+P".action.screenshot = { };
      "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = [ ];
      "Mod+Shift+E".action.quit = [ ];
      "Ctrl+Alt+Delete".action.quit = [ ];
      "Mod+Shift+P".action.power-off-monitors = [ ];
    };
  };
}

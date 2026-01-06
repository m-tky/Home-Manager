{ config, pkgs, ... }:
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
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    plugins = [
      # pkgs.hyprlandPlugins.hyprspace
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprfocus
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      # pkgs.hyprlandPlugins.hyprfocus
      pkgs.hyprlandPlugins.hyprexpo
    ];
    settings = {
      # 変数定義
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "fuzzel";
      "$browser" = "firefox";
      "$mainMod" = "SUPER";

      "gesture" = "3, horizontal, workspace";

      # 自動起動
      exec-once = [
        "udiskie"
        "nm-applet --sm-disable &"
        "wayvnc_server.sh"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "start.sh"
        # "hyprctl plugin load ${inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo}/lib/libhyprexpo.so"
        # "hyprctl plugin load ${pkgs.hyprlandPlugins.hyprfocus}/lib/libhyprfocus.so"
        "hyprctl plugin load ${pkgs.hyprlandPlugins.hyprexpo}/lib/libhyprexpo.so"
      ];

      env = [
        #   "XCURSOR_SIZE,24"
        #   "HYPRCURSOR_SIZE,24"
      ];

      # パーミッション
      permission = [
        "grim, screencopy, allow"
        "xdg-desktop-portal-hyprland, screencopy, allow"
        "hyprpm, plugin, allow"
      ];

      # 外観 (General)
      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 1;
        resize_on_border = true;
        allow_tearing = false;
        layout = "master";
      };

      # # 外観 (Decoration)
      decoration = {
        rounding = 5;

        active_opacity = 1.0;
        dim_inactive = true;
        dim_strength = 0.15;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # アニメーション
      animations = {
        enabled = true; # "yes, please :)" の代わりに `true` を使用
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # プラグイン設定
      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 3;
          bg_col = "rgb(89b4fa)";
          workspace_method = "center current";
          gesture_distance = 300;
        };
      };

      # レイアウト
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_on_top = true;
        mfact = 0.62;
        orientation = "left";
      };

      # 入力設定
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        repeat_delay = 250;
        repeat_rate = 25;
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      # デバイス固有設定
      device = [
        {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        }
      ];

      # キーバインド
      bind = [
        "$mainMod, W, exec, $browser"
        "$mainMod, C, killactive,"
        # "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, F, fullscreen, 1"
        "$mainMod SHIFT, F, fullscreen, 0"

        "$mainMod, K, layoutmsg, cycleprev"
        "$mainMod, J, layoutmsg, cyclenext"

        "$mainMod SHIFT, K, layoutmsg, swapprev"
        "$mainMod SHIFT, J, layoutmsg, swapnext"
        "$mainMod, SPACE, layoutmsg, swapwithmaster"

        "$mainMod CTRL, O, layoutmsg, orientationnext"
        "$mainMod SHIFT, M, layoutmsg, addmaster"
        "$mainMod SHIFT, N, layoutmsg, removemaster"

        # my custom keybinds
        "$mainMod, O, exec, hyprctl clients | grep -q 'initialClass: obsidian' && hyprctl dispatch togglespecialworkspace obsidian || obsidian &"
        "$mainMod SHIFT, O, movetoworkspace, special:obsidian"
        "$mainMod, Q, exec, $terminal"
        "$mainMod CTRL, F, exec, kitty --class terminal_yazi yazi"
        "$mainMod, N, exec, $HOME/.local/bin/notevim.sh"
        "$mainMod, B, exec, $HOME/.local/bin/toggle_blur.sh"
        "$mainMod CTRL, SPACE, exec, $HOME/.local/bin/raycast.sh"
        "$mainMod CTRL, T, exec, kitty --class task_manager $HOME/.local/bin/tm.sh"
        "$mainMod CTRL, C, exec, hyprpicker -a"

        # screenshot
        "$mainMod SHIFT, P, exec, hyprshot -m window --clipboard-only"
        "$mainMod CTRL, P, exec, hyprshot -m region --clipboard-only"

        "$mainMod CTRL, V, exec, cliphist list | fuzzel --dmenu --width 50 --lines 15 | cliphist decode | wl-copy"
        # lock
        "$mainMod CTRL, L, exec, hyprlock"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod SHIFT, T, exec, ~/.local/bin/translate.sh"
        "$mainMod SHIFT, W, exec, wiki.sh"
        "$mainMod, E, hyprexpo:expo, toggle"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
        "$mainMod, H, layoutmsg, mfact -0.01"
        "$mainMod, L, layoutmsg, mfact +0.01"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # ウィンドウ ルール
      # windowrule = [
      #   "suppressevent maximize, class:.*"
      #   "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      # ];

      # extraConfig = ''
      windowrule = [
        "match:title (Floating Window - Show Me The Key), float on"
        "match:class .*, suppress_event maximize"
        "match:class ^(matplotlib)$, float on"
        "match:class ^(viewnior)$, float on"
        "match:title ^(Open File)$ float on"
        "match:title ^(Choose File)$ float on"
        "match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus true"
        "match:title ^(Network Connection)$, float on, center on"
        "match:title ^(clipse)$, float on, center on, size 50% 80%"
        "match:class ^(Thunar)$, float on, size 60% 70%"
        "match:class ^(blueman-manager)$, float on"
        "match:class ^(pavucontrol)$, float on"
        "match:title ^(pop-up|bubble|dialog|task_dialog|menu|floating|floating_update)$, float on"
        "match:class ^(obsidian)$, workspace special:obsidian"
        "match:class ^(specialterm)$, workspace special:terminal"
        "match:class ^(pinentry)$, float on"
        "match:title ^(Administrator privileges required|Extension:|About Mozilla Firefox|About|Library|Pomodorolm)$, float on"
        "match:class ^(terminal_shutdown)$, float on, size 18% 10%, center on"
        "match:class ^(terminal_yazi)$, float on"
        "match:class ^(task_manager)$, float on, size 30% 30%"
        "match:class ^(note)$, float on"
        "match:class ^(=translation_kitty)$, float on, center on, size 35% 70%"
        "match:class ^(=select_language)$, float on, center on, size 17% 10%"
        "match:title ^(=floating-study-terminal)$, float on, center on, size 30% 30%"
        "match:title ^(launcher)$, float on, center on"
        "match:class ^(com.github.hluk.copyq)$, float on"
        "match:class ^(=terminal-bottom)$, float on"
        "match:class ^(foot)$, opacity 0.87 0.8"
        "match:class ^(nm-connection-editor)$, float on"
        "match:class ^(org.pulseaudio.pavucontrol)$, float on"
        "match:class ^(FindFile)$, float on, center on, size 60% 60%"
        "match:class ^(FindContent)$, float on, center on, size 60% 60%"
      ];
      # windowrule = match: class ^$, match: class ^$, xwayland 1, float on, noblur on, fullscreen off, pinned off
      # windowrule = match: class .* suppressevent maximize
      # windowrule = match: title ^(Floating Window - Show Me The Key)$, float on
      # windowrule = match: class ^(kitty)$, opacity 0.70
      # windowrule = match: title ^(Network Connection)$, float on, center on
      # windowrule = match: title ^(clipse)$, float on, center on, size 50% 80%
      # windowrule = match: class ^(Thunar)$, float on, size 60% 70%
      # windowrule = match: class ^(blueman-manager)$, float on
      # windowrule = match: class ^(pavucontrol)$, float on
      # windowrule = match: title ^(pop-up|bubble|dialog|task_dialog|menu|floating|floating_update)$, float on
      # windowrule = match: class ^(obsidian)$, workspace special:obsidian
      # windowrule = match: class ^(specialterm)$, workspace special:terminal, opacity 0.70
      # windowrule = match: class ^(pinentry)$, float on
      # windowrule = match: title ^(Administrator privileges required|Extension:|About Mozilla Firefox|About|Library|Pomodorolm)$, float on
      # windowrule = match: class ^(terminal_shutdown)$, float on, size 18% 10%, center on
      # windowrule = match: class ^(terminal_yazi)$, float on
      # windowrule = match: class ^(task_manager)$, float on, size 30% 30%
      # windowrule = match: class ^(note)$, float on
      # windowrule = match: class ^(=translation_kitty)$, float on, center on, size 35% 70%
      # windowrule = match: class ^(=select_language)$, float on, center on, size 17% 10%
      # windowrule = match: title ^(=floating-study-terminal)$, float on, center on, size 30% 30%
      # windowrule = match: title ^(launcher)$, float on, center on
      # windowrule = match: class ^(com.github.hluk.copyq)$, float on
      # windowrule = match: initialClass ^(=terminal-bottom)$, float on
      # windowrule = match: class ^(foot)$, opacity 0.87 0.8
      # windowrule = match: class ^(nm-connection-editor)$, float on
      # windowrule = match: class ^(org.pulseaudio.pavucontrol)$, float on
      # windowrule = match: class ^(FindFile)$, float on, center on, size 60% 60%
      # windowrule = match: class ^(FindContent)$, float on, center on, size 60% 60%
      # '';
      # windowrulev2 = [
      #   "float, initialClass:^(=terminal-bottom)$"
      #   "opacity 0.87 0.8,class:^(foot)$"
      #   "float, class:^(nm-connection-editor)$"
      #   "float,class: ^(org.pulseaudio.pavucontrol)$"
      #
      #   "float, class:^(FindFile)$"
      #   "center, class:^(FindFile)$"
      #   "size 60% 60%, class:^(FindFile)$"
      #
      #   "float, class:^(FindContent)$"
      #   "center, class:^(FindContent)$"
      #   "size 60% 60%, class:^(FindContent)$"
      #   # "opacity 0.70, class:^(specialterm)$"
      #   # "opacity 0.70, class:^(kitty)$"
      #   # "float, title:^(Network Connection)$"
      #   # "center, title:^(Network Connection)$"
      #   # "float, title:^(Floating Window - Show Me The Key)$"
      #   # "float, title:^(clipse)$"
      #   # "center, title:^(clipse)$"
      #   # "size 50% 80%, title:^(clipse)$"
      #   # "float, class:^(Thunar)$"
      #   # "size 60% 70%, class:^(Thunar)$"
      #   # "float, class:^(blueman-manager)$"
      #   # "workspace special:terminal, class:specialterm"
      #   # "opacity 0.87 0.8,class:^(specialfoot)$"
      #   # "noblur, class:^(specialfoot)$"
      #   # "workspace special:obsidian, class:^(obsidian)$"
      #   # "float, title:^(pop-up)$"
      #   # "float, title:^(bubble)$"
      #   # "float, title:^(dialog)$"
      #   # "float, title:^(dialog)$"
      #   # "float, title:^(task_dialog)$"
      #   # "float, title:^(menu)$"
      #   # "float, title:^(floating)$"
      #   # "float, title:^(floating_update)$"
      #   # "size 1000 600, title:^(floating_update)$"
      #   # "float, class:^(pinentry)$"
      #   # "float, title:^(Administrator privileges required)$"
      #   # "float, title:^(Extension:)$"
      #   # "float, title:^(About Mozilla Firefox)$"
      #   # "float, title:^(About)$"
      #   # "float, title:^(Library)$"
      #   # "float, title:^(Pomodorolm)$"
      #   # "float, class:terminal_shutdown$"
      #   # "size 18% 10%, title:terminal_shutdown$"
      #   # "center, class:terminal_shutdown$"
      #   # "float, class:terminal_yazi$"
      #   # "float, class:task_manager$"
      #   # "size 30% 30%, class:task_manager$"
      #   # "float, class:^(note)$"
      #   # "float, class:^(=translation_kitty)$"
      #   # "size 35% 70%, title:^(=translation_kitty)$"
      #   # "center, class:^(=translation_kitty)$"
      #   # "float, class:^(=select_language)$"
      #   # "size 17% 10%, class:^(=select_language)$"
      #   # "center, class:^(=select_language)$"
      #   # "float, title:^(launcher)$"
      #   # "center, title:^(launcher)$"
      #   # "float, class:^(com.github.hluk.copyq)$"
      # ];
    };
  };
}

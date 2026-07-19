# ~/dotfilem/linux/wm.nix
{
  pkgs,
  inputs,
  ...
}:
# let
#   # python3 を PATH に含めたカスタムパッケージを作成
#   wrappedNoctalia = pkgs.symlinkJoin {
#     name = "noctalia-shell-wrapped";
#     # inputs.noctalia からビルドされた元のパッケージを指定
#     paths = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];
#     buildInputs = [ pkgs.makeWrapper ];
#     postBuild = ''
#       wrapProgram $out/bin/noctalia-shell \
#         --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.python3 ]}
#     '';
#   };
# in

{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
    inputs.noctalia.homeModules.default
    ./fuzzel.nix
  ];
  services = {
    xremap = {
      enable = true;
      config.modmap = [
        {
          name = "Global";
          remap = {
            "KEY_CAPSLOCK" = {
              "alone" = "KEY_ESC";
              "held" = "KEY_LEFTCTRL";
            };
            "KEY_SPACE" = {
              "alone" = "KEY_SPACE";
              "held" = "KEY_LEFTSHIFT";
            };
          };
        }
      ];
    };
  };

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      font_family = "family=\"Moralerspace Argon\" style=\"Regular\"";
      bold_font = "family=\"Moralerspace Argon\" style=\"Bold\"";
      italic_font = "family=\"Moralerspace Radon\" style=\"Regular\"";
      bold_italic_font = "family=\"Moralerspace Radon\" style=\"Bold\"";
      font_size = "10.5";
      background_opacity = "0.75";
      allow_remote_control = "yes";
      enabled_layouts = "splits:split_axis=horizontal";
      enable_audio_bell = "no";

      background = "#192330";
      foreground = "#cdcecf";
      selection_background = "#2b3b51";
      selection_foreground = "#cdcecf";
      cursor_text_color = "#192330";
      url_color = "#81b29a";

      # Cursor
      # uncomment for reverse background
      # cursor none
      cursor = "#cdcecf";

      # Border
      active_border_color = "#719cd6";
      inactive_border_color = "#39506d";
      bell_border_color = "#f4a261";

      # Tabs
      active_tab_background = "#719cd6";
      active_tab_foreground = "#131a24";
      inactive_tab_background = "#2b3b51";
      inactive_tab_foreground = "#738091";

      # normal
      color0 = "#393b44";
      color1 = "#c94f6d";
      color2 = "#81b29a";
      color3 = "#dbc074";
      color4 = "#719cd6";
      color5 = "#9d79d6";
      color6 = "#63cdcf";
      color7 = "#dfdfe0";

      # bright
      color8 = "#575860";
      color9 = "#d16983";
      color10 = "#8ebaa4";
      color11 = "#e0c989";
      color12 = "#86abdc";
      color13 = "#baa1e2";
      color14 = "#7ad5d6";
      color15 = "#e4e4e5";

      # extended colors
      color16 = "#f4a261";
      color17 = "#d67ad2";
    };
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = "local config = wezterm.config_builder()

-- Keep WezTerm visually aligned with the Kitty configuration above.
config.colors = {
  foreground = '#cdcecf',
  background = '#192330',
  cursor_bg = '#cdcecf',
  cursor_fg = '#192330',
  cursor_border = '#cdcecf',
  selection_bg = '#2b3b51',
  selection_fg = '#cdcecf',
  ansi = {
    '#393b44', '#c94f6d', '#81b29a', '#dbc074',
    '#719cd6', '#9d79d6', '#63cdcf', '#dfdfe0',
  },
  brights = {
    '#575860', '#d16983', '#8ebaa4', '#e0c989',
    '#86abdc', '#baa1e2', '#7ad5d6', '#e4e4e5',
  },
  tab_bar = {
    background = '#192330',
    active_tab = {
      bg_color = '#719cd6',
      fg_color = '#131a24',
    },
    inactive_tab = {
      bg_color = '#2b3b51',
      fg_color = '#738091',
    },
    inactive_tab_hover = {
      bg_color = '#39506d',
      fg_color = '#cdcecf',
    },
    new_tab = {
      bg_color = '#2b3b51',
      fg_color = '#738091',
    },
    new_tab_hover = {
      bg_color = '#39506d',
      fg_color = '#cdcecf',
    },
  },
}
config.font_size = 10
config.font = wezterm.font_with_fallback({'Moralerspace Argon'}, { weight = 'Regular', style = 'Normal'})
config.font_rules = {
  -- Bold
  {
    intensity = \"Bold\",
    italic = false,
    font = wezterm.font(\"Moralerspace Argon\", { weight = \"Bold\" }),
  },
  -- Italic
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font(\"Moralerspace Radon\", { italic = true }),
  },
  -- Bold + Italic
  {
    intensity = \"Bold\",
    italic = true,
    font = wezterm.font(\"Moralerspace Radon\", { weight = \"Bold\", italic = true }),
  },
}

config.window_background_opacity = 0.75

-- Enable the Kitty graphics protocol for applications such as yazi and neovim.
config.enable_kitty_graphics = true

-- about tabbar
config.hide_tab_bar_if_only_one_tab = true

-- delete font warning
config.warn_about_missing_glyphs = false

return config";
  };
  home = {
    packages = with pkgs; [
      gtk3
      playerctl
      jq
      swayidle
      selectdefaultapplication
      power-profiles-daemon
      killall
      hyprshot
      hyprpicker
      fuzzel
      cliphist
      wlvncc
      nwg-displays
      pavucontrol
      wayvnc
      wf-recorder
      wl-clipboard
      foot
      libnotify
      translate-shell
      wiki-tui
      (writeShellScriptBin "pwec" ''
        # PATHに fzf, pulseaudio, gawk, gnused を通す
        PATH=${pkgs.pulseaudio}/bin:${pkgs.fzf}/bin:${pkgs.gawk}/bin:${pkgs.gnused}/bin:$PATH

        # 1. 既存のモジュールをアンロード
        EXISTING_ID=$(pactl list short modules | grep module-echo-cancel | cut -f1)
        if [ -n "$EXISTING_ID" ]; then
          echo "🔄 既存の設定(ID: $EXISTING_ID)を解除しました"
          pactl unload-module "$EXISTING_ID"
        fi

        # 2. スピーカー選択 (fzfを使用)
        echo "🔊 choose your speaker device to cancel:"
        # awkで名前だけ抽出して fzf に流し込む
        SINK_NAME=$(pactl list short sinks | awk '{print $2}' | fzf --prompt="Speaker > " --height=20% --layout=reverse --border)

        # キャンセルされたら終了
        if [ -z "$SINK_NAME" ]; then echo "canceled"; exit 1; fi

        # 3. マイク選択 (fzfを使用)
        echo "🎤 choose your mic:"
        SOURCE_NAME=$(pactl list short sources | grep -v "\.monitor" | awk '{print $2}' | fzf --prompt="Mic > " --height=20% --layout=reverse --border)

        if [ -z "$SOURCE_NAME" ]; then echo "canceled"; exit 1; fi

        # 4. 適用
        echo "🚀 applying echo cancellation with:"
        echo "   Speaker: $SINK_NAME"
        echo "   Mic    : $SOURCE_NAME"

        pactl load-module module-echo-cancel \
          use_master_format=1 \
          aec_method=webrtc \
          source_master="$SOURCE_NAME" \
          sink_master="$SINK_NAME" \
          source_name=EchoCancel_Mic \
          sink_name=EchoCancel_Speaker \
          aec_args="webrtc.gain_control=1 webrtc.extended_filter=1 webrtc.drift_compensation=1" > /dev/null

        echo "Done! choose 'EchoCancel_Mic' as your input device."
      '')
    ];
    # ++ [
    #   pkgsStable.libsForQt5.xwaylandvideobridge
    # ];
    file = {
      ".config/swaync" = {
        source = ../../assets/swaync;
        recursive = true;
      };
      ".config/foot/foot.ini" = {
        source = ../../assets/foot/foot.ini;
      };
      # ".config/fuzzel" = {
      #   source = ../config/fuzzel;
      #   recursive = true;
      # };
      ".config/fontconfig" = {
        source = ../../assets/fontconfig;
        recursive = true;
      };
    };
  };
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };
  programs.obs-studio.enable = true;
}

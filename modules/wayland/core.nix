# ~/dotfilem/linux/wm.nix
{
  pkgs,
  inputs,
  ...
}:
let
  # python3 を PATH に含めたカスタムパッケージを作成
  wrappedNoctalia = pkgs.symlinkJoin {
    name = "noctalia-shell-wrapped";
    # inputs.noctalia からビルドされた元のパッケージを指定
    paths = [ inputs.noctalia.packages.${pkgs.system}.default ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/noctalia-shell \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.python3 ]}
    '';
  };
in

{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
    inputs.noctalia.homeModules.default
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
    polkit-gnome.enable = true;
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
      font_size = "10";
      background_opacity = "0.80";
      allow_remote_control = "yes";
      enabled_layouts = "splits:split_axis=horizontal";
      enable_audio_bell = "no";
    };
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = "local config = wezterm.config_builder()
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 11
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
      helvum
      foot
      libnotify
      translate-shell
      wiki-tui
      swaynotificationcenter
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
        source = ../config/swaync;
        recursive = true;
      };
      ".config/foot/foot.ini" = {
        source = ../config/foot/foot.ini;
      };
      # ".config/fuzzel" = {
      #   source = ../config/fuzzel;
      #   recursive = true;
      # };
      ".config/fontconfig" = {
        source = ../config/fontconfig;
        recursive = true;
      };
    };
  };
  programs.noctalia-shell = {
    enable = true;
    package = wrappedNoctalia;
  };
  xdg.configFile."niri/config.kdl" = {
    source = ../config/niri/config.kdl;
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

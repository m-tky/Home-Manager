# ~/dotfilem/linux/wm.nix
{
  pkgs,
  pkgsStable,
  inputs,
  ...
}:

{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];
  services.xremap = {
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

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      font_family = "family=\"Moralerspace Argon\" style=\"Regular\"";
      bold_font = "family=\"Moralerspace Argon\" style=\"Bold\"";
      italic_font = "family=\"Moralerspace Radon\" style=\"Regular\"";
      bold_italic_font = "family=\"Moralerspace Radon\" style=\"Bold\"";
      font_size = "11.0";
      background_opacity = "0.70";
      allow_remote_control = "yes";
      enabled_layouts = "splits:split_axis=horizontal";
    };
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = "local config = wezterm.config_builder()
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 10.5
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
    packages =
      with pkgs;
      [
        # inputs.quickshell.packages.x86_64-linux.default
        gtk3
        playerctl
        jq
        selectdefaultapplication
        workstyle
        power-profiles-daemon
        killall
        hyprshot
        fuzzel
        wlvncc
        nwg-displays
        pavucontrol
        wayvnc
        wf-recorder
        wl-clipboard
        helvum
        nwg-drawer
        foot
        wdisplays
        libnotify
        translate-shell
        wiki-tui
        swaynotificationcenter
      ]
      ++ [
        pkgsStable.libsForQt5.xwaylandvideobridge
      ];
    file = {
      ".config/swaync" = {
        source = ../config/swaync;
        recursive = true;
      };
      ".config/workstyle" = {
        source = ../config/workstyle;
        recursive = true;
      };
      ".config/foot" = {
        source = ../config/foot;
        recursive = true;
      };
      ".config/fuzzel" = {
        source = ../config/fuzzel;
        recursive = true;
      };
      ".config/fontconfig" = {
        source = ../config/fontconfig;
        recursive = true;
      };
    };
  };
  services = {
    # copyq.enable = true;
  };
}

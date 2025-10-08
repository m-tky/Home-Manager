# ~/dotfilem/linux/wm.nix
{ pkgs, inputs, ... }:

{
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];
  services.xremap = {
    config.modmap = [
      {
        name = "Global";
        remap = {
          "CapsLock" = {
            "alone" = "Esc";
            "held" = "Ctrl_L";
          };
          "Space" = {
            "Alone" = "Space";
            "held" = "Shift_L";
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
      font_family = "family=\"Moralerspace Argon\" style=Regular";
      bold_font = "family=\"Moralerspace Argon\" style=Bold";
      italic_font = "family=\"Moralerspace Radon\" style=Regular";
      bold_italic_font = "family=\"Moralerspace Radon\" style=Bold";
      font_size = "10.5";
    };
    themeFile = "Catppuccin-Mocha";
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
    packages = with pkgs; [
      # inputs.quickshell.packages.x86_64-linux.default
      selectdefaultapplication
      workstyle
      power-profiles-daemon
      killall
      hyprshot
      walker
      wlvncc
      nwg-displays
      pavucontrol
      wayvnc
      kdePackages.xwaylandvideobridge
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
      ".config/walker" = {
        source = ../config/walker;
        recursive = true;
      };
    };
  };
  services = {
    copyq.enable = true;
  };
}

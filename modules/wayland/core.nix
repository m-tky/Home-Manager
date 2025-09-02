# ~/dotfiles/linux/wm.nix
{ pkgs, ... }:

{
  # programs.kitty = {
  #   enable = true;
  #   enableGitIntegration = true;
  #   shellIntegration.enableZshIntegration = true;
  #   settings = {
  #     font_family = "family=\"Moralerspace Argon HWNF\" style=Regular";
  #     bold_font = "family=\"Moralerspace Argon HWNF\" style=Bold";
  #     italic_font = "family=\"Moralerspace Radon HWNF\" style=Regular";
  #     bold_italic_font = "family=\"Moralerspace Radon HWNF\" style=Bold";
  #     font_size = "11";
  #   };
  #   themeFile = "Catppuccin-Mocha";
  # };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = "local config = wezterm.config_builder()
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 11.5

config.font = wezterm.font_with_fallback{'Moralerspace Argon NF'}

config.font_rules = {
  {
    intensity = 'Normal',
    italic = false,
    font = wezterm.font(\"Moralerspace Argon NF\", { weight = \"Bold\" }),
  },
  -- Bold
  {
    intensity = \"Bold\",
    italic = false,
    font = wezterm.font(\"Moralerspace Argon NF\", { weight = \"Bold\" }),
  },
  -- Italic
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font(\"Moralerspace Radon NF\", { italic = true }),
  },
  -- Bold + Italic
  {
    intensity = \"Bold\",
    italic = true,
    font = wezterm.font(\"Moralerspace Radon NF\", { weight = \"Bold\", italic = true }),
  },
}
return config";
  };
  home = {
    packages = with pkgs; [
      # inputs.quickshell.packages.x86_64-linux.default
      hyprshot
      walker
      wlvncc
      nwg-displays
      pavucontrol
      wayvnc
      libsForQt5.xwaylandvideobridge
      wf-recorder
      wl-clipboard
      helvum
      nwg-drawer
      flameshot
      foot
      wdisplays
      libnotify
      translate-shell
      wiki-tui
    ];
    file = {
      ".config/foot" = {
        source = ../config/foot;
        recursive = true;
      };
    };
  };
  services = {
    copyq.enable = true;
  };
}

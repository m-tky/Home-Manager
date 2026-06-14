# Fuzzel — declarative config via home-manager.
#
# `programs.fuzzel` writes ~/.config/fuzzel/fuzzel.ini from the settings
# below, so the file becomes read-only / store-managed and matches the
# rest of the dotfiles. The palette lines up 1:1 with the wayland-conky
# panel (Nightfox), so fuzzel prompts read as part of the same surface
# as the conky widget.
#
# Theme switch: change every `colors.*` value to one of the palettes in
# /home/user/Code/wayland-conky/modules/home.nix (carbonfox, duskfox,
# catppuccin-mocha, …) and rebuild. The matching wayland-conky theme is
# `programs.wayland-conky.theme.variant`.
{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    package = pkgs.fuzzel;
    settings = {
      main = {
        icon-theme = "Papirus-Dark";
        # Matched to kitty's `font_size 10` and wayland-conky's panel
        # font so fuzzel / kitty / conky read as one surface. Updating
        # any one of the three to a new size: update all three.
        # The Nerd Font fallback is for PUA icon glyphs (search,
        # trash, stopwatch, …) that palette.py prefixes onto rows —
        # Moralerspace doesn't ship them, fontconfig falls through to
        # FiraCode Nerd Font Mono per-character.
        font = "Moralerspace Argon:size=10,FiraCode Nerd Font Mono:size=10";
        prompt = ''"> "'';
      };
      # ── Nightfox palette ─────────────────────────────────────────────
      # Hex values match `palettes.nightfox` in wayland-conky/modules/home.nix.
      # The trailing two hex chars are alpha:
      #   background `cc` = ~80% opaque, lets the wallpaper show through
      #   selection `80`  = 50% opaque, soft highlight on the row
      #   everything else `ff` = fully opaque
      colors = {
        background      = "1e2030cc";
        text            = "cdcecfff";
        prompt          = "719cd6ff";
        placeholder     = "71839bff";
        input           = "cdcecfff";
        match           = "dbc074ff";
        selection       = "9d79d680";
        selection-text  = "cdcecfff";
        selection-match = "dbc074ff";
        counter         = "71839bff";
        border          = "719cd6ff";
      };
      border = {
        radius = 8;
        width = 1;
      };
    };
  };
}

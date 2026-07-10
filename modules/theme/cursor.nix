{ pkgs, inputs, ... }:
{
  home.pointerCursor = {
    enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 26;
    gtk.enable = true;
  };
}

{ pkgs, inputs, ... }:
{
  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 26;
    gtk.enable = true;
  };
}

# home.nix など
{ pkgs, ... }:
{

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "";
          path = "${../../config/hypr/backgrounds/Small-memory-sunrise.jpg}";
          fit_mode = "cover";
        }
      ];
    };
  };
}

# home.nix など
{ pkgs, ... }:
{
  home.file = {
    "Pictures/Wallpapers/Small-memory-sunrise.jpg".source =
      ../../config/hypr/backgrounds/Small-memory-sunrise.jpg;
    "Pictures/Wallpapers/landscape-mountain-peak3440x1440.jpg".source =
      ../../config/hypr/backgrounds/731_landscape-mountain-peak_3440x1440.jpg;
    "Pictures/Wallpapers/7517_falcade-bl-italy_3440x1440.jpg".source =
      ../../config/hypr/backgrounds/7517_falcade-bl-italy_3440x1440.jpg;
    "Pictures/Wallpapers/7633_reflection-of-the-forest-in-the-lake_3440x1440.jpg".source =
      ../../config/hypr/backgrounds/7633_reflection-of-the-forest-in-the-lake_3440x1440.jpg;
    "Pictures/Wallpapers/1725_mountains-mountain-peaks_3440x1440.jpg".source =
      ../../config/hypr/backgrounds/1725_mountains-mountain-peaks_3440x1440.jpg;
  };
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

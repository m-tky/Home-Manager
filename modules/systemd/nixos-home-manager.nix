{
  config,
  pkgs,
  lib,
  ...
}:

let
  flakePath = config.home.homeDirectory + "/.config/home-manager";
  username = config.home.username;
in
{
  systemd.user.services.home-manager = {
    Unit = {
      Description = "Home Manager";
      Documentation = "https://github.com/nix-community/home-manager";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "${config.home.profileDirectory}/bin/home-manager switch --flake ${flakePath}#${username}@nixos";
      Restart = "on-failure";
      Environment = [
        "HOME=/home/${username}"
        "USER=${username}"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

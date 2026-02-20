{
  description = "Standalone home-manager dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";

    # settings for hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nixCats-nvim = {
      url = "github:m-tky/Nixcats";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      noctalia,
      ...
    }@inputs:
    let
      # 各マシンごとに設定（system, path, username, homeDirectory）を指定
      userMachines = {
        m75q = {
          path = ./home/m75q.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        nixos = {
          path = ./home/nixos.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        thinkpad = {
          path = ./home/thinkpad.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        mini = {
          path = ./home/mini.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        xiaomipad = {
          path = ./home/xiaomipad.nix;
          system = "aarch64-linux";
          username = "nix-on-droid";
          homeDirectory = "/data/data/com.termux.nix/files/home";
        };
      };
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs' (
        machine: cfg:
        let
          fullName = "${cfg.username}@${machine}";
          system = cfg.system;
        in
        {
          name = fullName;
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              # hostPlatform = system;
              inherit system;
              config.allowUnfree = true;
            };
            modules = [
              inputs.catppuccin.homeModules.catppuccin
              inputs.niri-flake.homeModules.niri
              cfg.path
              {
                home = {
                  username = cfg.username;
                  homeDirectory = cfg.homeDirectory;
                  stateVersion = "26.05";
                };
              }
            ];
            extraSpecialArgs = {
              inherit inputs;
              hostName = machine;
            };
          };
        }
      ) userMachines;
    };
}

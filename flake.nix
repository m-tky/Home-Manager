{
  description = "Standalone home-manager dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
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
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
    #   inputs.hyprland.follows = "hyprland";
    # };
    # astal.url = "github:aylur/astal";
    # ags.url = "github:aylur/ags";
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    catppuccin.url = "github:catppuccin/nix";
    nixCats-nvim = {
      url = "github:m-tky/Nixcats";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
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
          pkgsStable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          name = fullName;
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            extraSpecialArgs = { inherit inputs pkgsStable; };
            modules = [
              # inputs.nixvim.homeModules.nixvim
              inputs.catppuccin.homeModules.catppuccin
              cfg.path
              {
                home = {
                  username = cfg.username;
                  homeDirectory = cfg.homeDirectory;
                  stateVersion = "25.05";
                };
              }
            ];
          };
        }
      ) userMachines;
    };
}

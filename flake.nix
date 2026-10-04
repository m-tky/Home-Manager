{
  description = "Standalone home-manager dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";

    nixCats-nvim = {
      url = "github:m-tky/Nixcats";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ik-llama-cpp = {
      url = "github:ikawrakow/ik_llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    skk-mozc = {
      url = "github:m-tky/skk-mozc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-conky = {
      url = "github:m-tky/alarme-conky";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llama-cpp.url = "github:ggml-org/llama.cpp";
    hermes-agent = {
      url = "github:NousResearch/hermes-agent/fix/desktop-electron-headers";
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
          path = ./hosts/m75q.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        nixos = {
          path = ./hosts/nixos.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        thinkpad = {
          path = ./hosts/thinkpad.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        mini = {
          path = ./hosts/mini.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
        xiaomipad = {
          path = ./hosts/xiaomipad.nix;
          system = "aarch64-linux";
          username = "nix-on-droid";
          homeDirectory = "/data/data/com.termux.nix/files/home";
        };
        minawa = {
          path = ./hosts/minawa.nix;
          system = "x86_64-linux";
          username = "takuya";
          homeDirectory = "/home/takuya";
          cudaSupport = true;
        };
        wsl = {
          path = ./hosts/wsl.nix;
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
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
              config = {
                allowUnfree = true;
                cudaSupport = cfg.cudaSupport or false;
              };
            };
            modules = [
              inputs.niri-flake.homeModules.config
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
              inherit
                inputs
                noctalia
                ;
              hostName = machine;
            };
          };
        }
      ) userMachines;
    };
}

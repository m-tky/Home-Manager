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
    niri-flake = {
      url = "github:sodiboo/niri-flake/very-refactor";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
    };
    ik-llama-cpp = {
      url = "github:ikawrakow/ik_llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-patina = {
      url = "github:michel-kraemer/zsh-patina";
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
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
    };
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      noctalia,
      antigravity-nix,
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
        # WSL (Ubuntu) 上で使う、GUI 非依存の開発環境。
        # WSL の Linux ユーザー名を変えた場合は、ここだけ更新する。
        gmo = {
          path = ./hosts/gmo.nix;
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
              overlays = [
                (_: prev: {
                  gnome-control-center = prev.gnome-control-center.overrideAttrs {
                    doCheck = false;
                  };
                  openldap = prev.openldap.overrideAttrs {
                    doCheck = false;
                  };
                })
              ];
            };
            modules = [
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
              inherit
                inputs
                antigravity-nix
                noctalia
                ;
              hostName = machine;
            };
          };
        }
      ) userMachines;
    };
}

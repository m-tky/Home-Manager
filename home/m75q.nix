{
  config,
  pkgs,
  inputs,
  ...
}:
let
  llama-cpu =
    (inputs.ik-llama-cpp.packages.${pkgs.system}.default.override {
      useVulkan = false;
      useCuda = false;
    }).overrideAttrs
      (old: {
        NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or [ ]) ++ [
          "-mtune=znver3"
          "-O3"
          "-fno-math-errno"
          "-fno-trapping-math"
        ];
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          "-DGGML_AVX2=ON"
          "-DGGML_FMA=ON"
          "-DGGML_F16C=ON"
          "-DGGML_NATIVE=ON"
          "-DGGML_OPENMP=ON"
          "-DGGML_AVX512=OFF"
          "-DGGML_BLAS=OFF"
          "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
        ];
        # ★ overrideAttrsの属性としてではなくpreconfigureでexportする
        preConfigure = ''
          export NIX_ENFORCE_NO_NATIVE=0
        ''
        + (old.preConfigure or "");
      });
  customJan = pkgs.callPackage ../modules/jan.nix { };
in
{
  home.packages = with pkgs; [
    ryubing
    arduino-ide
    customJan
    # inputs.powerinfer.packages.${pkgs.system}.default
    llama-cpu
  ];
  services.ollama = {
    enable = true;
    environmentVariables = {
      OLLAMA_LLM_LIBRARY = "cpu";
      OLLAMA_HOST = "0.0.0.0:11434";
    };
  };
  systemd.user = {
    services."obsidianDocs-sync" = {
      Unit = {
        Description = "Sync Obsidian Docs to WebDAV";
      };
      Service = {
        Type = "Oneshot";
        ExecStart = "${config.home.homeDirectory}/.local/bin/rcloneObsidianDocuments.sh";
      };
    };
    timers."obsidianDocs-sync" = {
      Unit = {
        Description = "Timer to sync Obsidian Docs to WebDAV every 15 minutes";
      };
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "15min";
        AccuracySec = "1min";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
  programs.home-manager.enable = true;
  systemd.user.startServices = true;
  imports = [
    ../modules/cli.nix
    ../modules/editor/default.nix
    ../modules/gui.nix
    ../modules/localization/fcitx5.nix
    ../modules/theme/default.nix
    ../modules/wayland/core.nix
    ../modules/wayland/niri/default.nix
    ../modules/systemd/m75q-home-manager.nix
    ../modules/cad/default.nix
    ../modules/cloud/default.nix
  ];
}

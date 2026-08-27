{
  config,
  pkgs,
  inputs,
  ...
}:
let
  llama-cuda = inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.cuda.overrideAttrs (old: {
    NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or [ ]) ++ [
      "-march=native"
      "-mtune=native"
      "-O3"
      "-fno-math-errno"
      "-fno-trapping-math"
    ];

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DGGML_NATIVE=ON"
      "-DGGML_OPENMP=ON"

      # Core Ultra 7 265
      "-DGGML_AVX2=ON"
      "-DGGML_FMA=ON"
      "-DGGML_F16C=ON"
      "-DGGML_AVX512=OFF"

      # RTX 2000 Ada = compute capability 8.9
      "-DCMAKE_CUDA_ARCHITECTURES=89"

      "-DGGML_BLAS=OFF"
      "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
    ];

    preConfigure = ''
      export NIX_ENFORCE_NO_NATIVE=0
    ''
    + (old.preConfigure or "");
  });
in
{
  imports = [
    ../profiles/desktop.nix
    ../features/wayland/niri/default.nix
  ];

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
    };
  };
  home.packages = [
    llama-cuda
  ];
  xdg.enable = true;

  systemd.user.services.llama-server = {
    Unit = {
      Description = "llama.cpp Model Router";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";

      ExecStart = ''
        ${llama-cuda}/bin/llama-server \
          --models-dir %h/.local/share/llama/models \
          --models-max 1 \
          --models-autoload \
          --host 0.0.0.0 \
          --port 8080 \
          --ctx-size 16384 \
          --gpu-layers all \
          --flash-attn on \
          --cache-type-k q8_0 \
          --cache-type-v q8_0 \
          --jinja \
          --sleep-idle-seconds 300
      '';

      Restart = "on-failure";
      RestartSec = 3;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

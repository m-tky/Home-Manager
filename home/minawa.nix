{
  config,
  pkgs,
  inputs,
  ...
}:
let
  llama-cuda =
    (inputs.ik-llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      useVulkan = false;
      useCuda = true;
    }).overrideAttrs
      (old: {
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

          # Intel Core Ultra 7 265 / Arrow Lake 向け。
          # AVX2/FMA/F16C は有効、AVX512 は基本OFFでよい。
          "-DGGML_AVX2=ON"
          "-DGGML_FMA=ON"
          "-DGGML_F16C=ON"
          "-DGGML_AVX512=OFF"

          # RTX 2000 Ada Generation = Ada Lovelace, compute capability 8.9
          "-DGGML_CUDA=ON"
          "-DCMAKE_CUDA_ARCHITECTURES=89"

          # BLASはGPU推論メインなら不要寄り
          "-DGGML_BLAS=OFF"

          "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
        ];

        preConfigure = ''
          export NIX_ENFORCE_NO_NATIVE=0
        ''
        + (old.preConfigure or "");
      });

  customJan = pkgs.callPackage ../modules/jan.nix { };
in
{
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
  ];

  programs = {
    firefox.enable = true;
  };
  home.packages = [
    llama-cuda
  ];
  xdg.enable = true;
}

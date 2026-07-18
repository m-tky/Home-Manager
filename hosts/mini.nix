{
  config,
  pkgs,
  inputs,
  ...
}:
let
  llama-vulkan =
    (inputs.ik-llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      # もし iGPU を活用したいならここを true に（要ハードウェア設定）
      useVulkan = true;
    }).overrideAttrs
      (old: {
        # CPU 最適化フラグを注入
        NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or [ ]) ++ [
          # if 5650GE, znver3
          "-march=znver2"
          "-mtune=znver2"
        ];
        # CMake に SIMD を使うことを明示的に教える
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          "-DGGML_AVX2=ON"
          "-DGGML_FMA=ON"
          "-DGGML_F16C=ON"
        ];
      });
  customJan = pkgs.callPackage ../features/desktop/jan.nix { };
in
{
  # services.ollama = {
  #   enable = true;
  #   environmentVariables = {
  #     OLLAMA_LLM_LIBRARY = "cpu";
  #     OLLAMA_HOST = "0.0.0.0:11434";
  #   };
  # };
  imports = [
    ../profiles/desktop.nix
    ../features/wayland/niri/default.nix
  ];
  home.packages = with pkgs; [
    pandoc
    # home.nix
    llama-vulkan
    customJan
  ];
}

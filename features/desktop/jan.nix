{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  appimageTools,
  makeWrapper,
  config,
  # 明示的に指定しない場合は config や stdenv から自動判定
  cudaSupport ? config.cudaSupport or false,
  rocmSupport ?
    stdenv.isLinux && (builtins.match ".*rocm.*" (stdenv.hostPlatform.gcc.arch or "") != null), # 簡易判定
  cudaPackages ? pkgs.cudaPackages,
}:

let
  pname = "Jan";
  version = "0.7.8";

  meta = with lib; {
    description = "Jan is an open source alternative to ChatGPT that runs 100% offline";
    homepage = "https://github.com/janhq/jan";
    license = licenses.asl20;
    mainProgram = "jan";
    platforms = platforms.linux ++ platforms.darwin;
  };

  # Linux (AppImage) 用の定義
  linux =
    let
      src = fetchurl {
        url = "https://github.com/janhq/jan/releases/download/v${version}/jan_${version}_amd64.AppImage";
        hash = "sha256-L8d8OQ5Cl4RpO+cQOq9he+2Ejdnf0yIDAITpQ487lyU=";
      };
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
        cp -r ${appimageContents}/usr/share/icons $out/share
      '';
      # substituteInPlace $out/share/applications/Jan.desktop \
      #   --replace 'Exec=AppRun' 'Exec=${pname}'

      # 各アクセラレーション用のライブラリを追加
      extraPkgs =
        pkgs:
        with pkgs;
        [
          libGL
          vulkan-loader
        ]
        ++ lib.optionals cudaSupport [
          cudaPackages.cudatoolkit
        ]
        ++ lib.optionals rocmSupport [
          rocmPackages.rocm-runtime
          rocmPackages.clr
          rocmPackages.hip-common
        ];

      inherit meta;
    };

  # Darwin (macOS) 用の定義
  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchzip {
      url = "https://github.com/janhq/jan/releases/download/v${version}/jan-mac-universal-${version}.zip";
      hash = "sha256-stTsLKE+2gUKAVwJ2/gOckoL6Nygwr0rkugD1jGj1w4=";
    };

    dontUnpack = true;
    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/${pname}.app
      cp -R $src/. $out/Applications/${pname}.app/
      mkdir -p $out/bin
      makeWrapper "$out/Applications/${pname}.app/Contents/MacOS/${pname}" $out/bin/${pname}
      runHook postInstall
    '';
  };

in
if stdenv.isDarwin then darwin else linux

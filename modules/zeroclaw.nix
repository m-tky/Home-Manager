{
  config,
  lib,
  pkgs,
  zeroclaw,
  ...
}:

let
  zeroclawPkg = pkgs.rustPlatform.buildRustPackage {
    pname = "zeroclaw";
    version = "git";

    # upstream flake をそのまま src に
    src = zeroclaw;

    cargoLock = {
      lockFile = "${zeroclaw}/Cargo.lock";
    };

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.openssl
    ];

    OPENSSL_NO_VENDOR = 1;
    doCheck = false;

    meta = with lib; {
      description = "ZeroClaw AI agent";
      homepage = "https://github.com/zeroclaw-labs/zeroclaw";
      license = licenses.mit;
      mainProgram = "zeroclaw";
    };
  };
in
{
  ### インストール（これだけで ~/.nix-profile/bin に入る）
  home.packages = [
    zeroclawPkg
  ];

  # home.file.".config/zeroclaw/config.toml".text = ''
  #   provider = "openrouter"
  #   model = "deepseek-chat"
  #
  #   [openrouter]
  #   api_key = "env:OPENROUTER_API_KEY"
  # '';
}

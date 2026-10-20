{ inputs, pkgs, ... }:
{
  # GUI を必要としない、PC・WSL・nix-on-droid で共用する開発ツール。
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts-cjk-serif # 明朝体
    noto-fonts-cjk-sans # ゴシック体
    libertinus
    typst
    bun
    zsh-patina
    gh
    delta
    openssh
    rsync
    curl
    file
    shellcheck
    ripgrep
    jq
    yq-go
    tree
    unzip
    zip
  ];

  xdg.configFile = {
    "zsh-patina/nightfox.toml".source = ../../../assets/zsh-patina/nightfox.toml;
    "zsh-patina/config.toml".source = ../../../assets/zsh-patina/config.toml;
  };
}

{
  imports = [
    ./gtk.nix
    ./qt/default.nix
    ./cursor.nix
  ];
  catppuccin = {
    flavor = "mocha";
    accent = "blue";
    bat.enable = true;
    bottom.enable = true;
    chromium.enable = true;
    delta.enable = true;
    foot.enable = true;
    fcitx5.enable = true;
    fzf.enable = true;
    gtk = {
      icon = {
        enable = false;
      };
    };
    firefox.enable = true;
    hyprland.enable = true;
    kvantum.enable = true;
    lazygit.enable = true;
    starship.enable = true;
    thunderbird.enable = true;
    tmux.enable = true;
    wezterm.enable = true;
    kitty.enable = true;
    yazi.enable = true;
    hyprlock.enable = true;
    vscode.profiles.default.enable = true;
    zathura.enable = true;
    zellij.enable = true;
    zed.enable = true;
    zsh-syntax-highlighting.enable = true;
  };
}

{ inputs, pkgs, ... }:
let
  nixvimConfig = import ./config.nix;
  pluginsDir = ./plugins;
  pluginModules = import pluginsDir;
  # keybinds = import ./keybinds.nix;
in
{
  imports = 
    builtins.attrValues pluginModules
    ++ [ 
      # keybinds
    ];

  programs.nixvim = nixvimConfig.settings;
}

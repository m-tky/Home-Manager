{
  programs.nixvim = {
    plugins.quarto = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.ft = [
          "quarto"
          "markdown"
        ];
      };
      settings = {
        codeRunner = {
          enabled = true;
          default_method = "molten";
        };
        lspFeatures = {
          languages = [
            "r"
            "python"
            "rust"
          ];
          chunks = "all";
          diagnostics = {
            enabled = true;
            triggers = [ "BufWritePost" ];
          };
          completion = {
            enabled = true;
          };
        };
      };
    };
  };
  xdg.configFile."nvim/ftplugin/markdown.lua".text = ''
    if package.loaded["quarto"] then
      require("quarto").activate()
    end
  '';
}

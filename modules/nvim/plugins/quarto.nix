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
    extraConfigLua = ''
      local ok, quarto = pcall(require, 'quarto')
      if ok then 
        quarto.activate()
      end
    '';
  };
}

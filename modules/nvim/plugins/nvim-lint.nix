{
  programs.nixvim = {
    plugins.lint = {
      enable = false;
      lazyLoad = {
        enable = true;
        settings.event = [ "LspAttach" "BufWritePre" ];
      };
      lintersByFt = { }
        };
    };
  }

{
  programs.nixvim = {
    plugins = {
      highlight-colors = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings.event = [ "VimEnter" ];
        };
      };
    };
  };
}

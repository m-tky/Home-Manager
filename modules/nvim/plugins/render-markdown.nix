{
  programs.nixvim = {
    plugins.render-markdown = {
      enable = true;
      settings = {
        completions.blink.enabled = true;
        heading = {
          enabled = false;
          render_modes = false;
          width = "block";
          left_pad = 0;
          right_pad = 4;
          sign = true;
          icons = { };
        };
        code = {
          width = "block";
          right_pad = 4;
        };
      };
      lazyLoad = {
        enable = true;
        settings.ft = [ "markdown" ];
      };
    };
  };
}

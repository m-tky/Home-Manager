{
  programs.nixvim = {
    plugins.smear-cursor = {
      enable = true;
      luaConfig.post = ''
        require('smear_cursor').setup({
          stiffness = 0.5,
          trailing_stiffness = 0.49,
          never_draw_over_target = false,
        })
      '';
      lazyLoad = {
        enable = true;
        settings.events = [ "VimEnter" ];
      };
    };
  };
}

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
    extraConfigLua = ''
      -- Noiceウィンドウに入ったときに、SmearCursorを無効化する
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "^Noice*" },
        callback = function()
          if require("smear_cursor").enabled then
            require("smear_cursor").toggle()
          end
        end,
      })

      -- Noiceウィンドウから離れるときに、SmearCursorを有効化する
      vim.api.nvim_create_autocmd("BufLeave", {
        pattern = { "^Noice*" },
        callback = function()
          -- smear_cursorが無効であれば有効化
          if not require("smear_cursor").enabled then
            require("smear_cursor").toggle()
          end
        end,
      })
    '';
  };
}

{
  programs.nixvim = {
    plugins.hydra = {
      luaConfig.pre = ''
        local function keys(str)
          return function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
          end
        end
      '';
      enable = true;
      hydras = [
        {
          name = "QuartoNavigator";
          hint = {
            __raw = ''
              [[
              _j_/_k_: move down/up  _r_: run cell
              _l_: run line  _R_: run above
              ^^     _<esc>_/_q_: exit ]]
            '';
          };
          config = {
            color = "pink";
            invoke_on_body = true;
          };
          mode = [ "n" ];
          body = "<leader>h";
          heads = [
            [
              "j"
              { __raw = ''keys(']b')''; }
            ]
            [
              "k"
              { __raw = ''keys('[b')''; }
            ]
            [
              "r"
              ":QuartoSend<CR>"
            ]
            [
              "l"
              "QuartoSendLine<CR>"
            ]
            [
              "R"
              "QuartoSendAbove<CR>"
            ]
            [
              "<esc>"
              null
              { exit = true; }
            ]
            [
              "q"
              null
              { exit = true; }
            ]
          ];
        }
      ];
    };
  };
}

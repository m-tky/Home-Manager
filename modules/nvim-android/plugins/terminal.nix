{
  programs.nixvim = {
    plugins = {
      yazi = {
        enable = true;
        settings = {
          keymaps = {
            open_file_in_horizontal_split = "<c-x>";
          };
        };
        lazyLoad = {
          enable = true;
          settings.key = [ "<leader>y" ];
        };
      };
      lazygit = {
        enable = true;
      };
      toggleterm = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings = {
            keys = [ "<leader>t" ];
            cmd = [
              "TermExec"
              "TermRepl"
              "ToggleTerm"
              "ToggleTermSendCurrentLine"
              "ToggleTermSendVisualSelection"
            ];
          };
        };
        luaConfig.post = ''
          require("toggleterm").setup{
            start_in_insert = true,
            env = { TOGGLETERM_IS_ACTIVE = "1", },
          }
        '';
        settings = {
          size = ''
            function(term)
              if term.direction == "horizontal" then
                return 13
              elseif term.direction == "vertical" then
                return vim.o.columns * 0.3
              end
            end
          '';
          # open_mapping = ''"<leader>tt"'';
          hide_numbers = true;
          start_in_insert = true;
          insert_mappings = true;
          direction = "float";
          float_opts.__raw = ''
            {
                      border = "rounded",
                      width = function()
                        return math.floor(vim.o.columns * 0.9)
                      end,
                      height = function()
                        return math.floor(vim.o.lines * 0.45)
                      end,
                      row = 1,
                      col = function()
                        return math.floor((vim.o.columns - vim.o.columns * 0.9) / 2)
                      end,
                      winblend = 20,
                      zindex = 150,
                      title_pos = "center",
                    }'';
        };
      };
      diffview = {
        enable = true;
      };
    };

    keymaps = [
      {
        action = "<cmd>Yazi<cr>";
        key = "<leader>y-";
        options = {
          desc = "Open at the current file";
          silent = true;
        };
      }
      {
        action = "<cmd>Yazi cwd<cr>";
        key = "<leader>yc";
        options = {
          desc = "Yazi: Change working directory";
          silent = true;
        };
      }
      {
        action = "<cmd>Yazi toggle<cr>";
        key = "<leader>yt";
        options = {
          desc = "Resume the last session";
          silent = true;
        };
      }
      {
        action = "<cmd>LazyGit<CR>";
        key = "<leader>gg";
        options = {
          desc = "Open LazyGit";
          silent = true;
        };
      }
      {
        action = "<cmd>DiffviewOpen<CR>";
        key = "<leader>gd";
        options = {
          desc = "Open Diffview";
          silent = true;
        };
      }
      # ToggleTerm
      {
        action = "<cmd>ToggleTerm direction=float name=default<CR>";
        key = "<leader>tt";
        options = {
          desc = "Open Default";
          silent = true;
        };
      }
      {
        action = "<cmd>ToggleTerm direction=vertical name=repl<CR>";
        key = "<leader>tr";
        options = {
          desc = "Open REPL";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('toggleterm').send_lines_to_terminal('visual_selection', false, { args = 'repl' })<CR>";
        key = "<leader>tv";
        options = {
          desc = "Send selected lines";
          silent = false;
        };
      }
      # {
      #   action.__raw = "set_opfunc(function(motion_type)
      #     require('toggleterm').send_lines_to_terminal(motion_type, false, { args = 'repl' })
      #   end)
      #   vim.api.nvim_feedkeys(\"ggg@G''\", 'n', false)";
      #   key = "<leader>tf";
      #   options = {
      #     desc = "Send the whole file";
      #     silent = false;
      #   };
      # }
    ];
    extraConfigLua = ''
      require("which-key").add({
        { "<leader>y", group = "Yazi" },
        { "<leader>g", group = "Git" },
        { "<leader>t", group = "Terminal" },
        { "<leader>tt", group = "Open Terminal" },
      })
    '';
  };
}

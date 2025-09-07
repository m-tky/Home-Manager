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
    keymaps = [
# local runner = require("quarto.runner")
# vim.keymap.set("n", "<localleader>rc", runner.run_cell,  { desc = "run cell", silent = true })
# vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
# vim.keymap.set("n", "<localleader>rA", runner.run_all,   { desc = "run all cells", silent = true })
# vim.keymap.set("n", "<localleader>rl", runner.run_line,  { desc = "run line", silent = true })
# vim.keymap.set("v", "<localleader>r",  runner.run_range, { desc = "run visual range", silent = true })
# vim.keymap.set("n", "<localleader>RA", function()
#   runner.run_all(true)
# end, { desc = "run all cells of all languages", silent = true })
      {
        action = "require('quarto.runner').run_cell";
        key = "<leader>qc";
        options = {
          desc = "run cell";
          silent = true;
        };
      }
      {
        action = "require('quarto.runner').run_above";
        key = "<leader>qa";
        options = {
          desc = "run cell and above";
          silent = true;
        };
      }
      {
        action = "require('quarto.runner').run_all";
        key = "<leader>qA";
        options = {
          desc = "run all cells";
          silent = true;
        };
      }
      {
        action = "require('quarto.runner').run_line";
        key = "<leader>ql";
        options = {
          desc = "run line";
          silent = true;
        };
      }
      {
        action = "require('quarto.runner').run_range";
        key = "<leader>qr";
        options = {
          desc = "run visual range";
          silent = true;
        };
      }
    ];
  };
  xdg.configFile."nvim/ftplugin/markdown.lua".text = ''
    if package.loaded["quarto"] then
      require("quarto").activate()
    end
  '';
}

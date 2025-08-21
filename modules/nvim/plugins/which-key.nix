{
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      win = {
        border = "rounded";
        zindex = 1000;
        # wo.winblend = 20;
        # height = {
        #   min = 10;
        #   max = 20;
        # };
        # width = 0.4;
        # row = 1;
        # col.__raw = ''vim.o.columns - math.floor(vim.o.columns * 0.4) - 2'';
      };
      # layout = {
      #   width = {
      #     min = 20;
      #     max = 0.4;
      #   };
      #   align = "left";
      # };
    };
  };
  programs.nixvim.extraConfigLua = ''
    require("which-key").add({
      { "<leader>y", group = "Yazi" },
      { "<leader>g", group = "Git" },

      -- telescope
      { "<leader>f", group = "Telescope" },

      -- lsp
      { "<leader>l", group = "LSP" },
      { "g", group = "Move" },

      --surround
      { "<leader>s", group = "Surround" },

      { "<leader>sy", group = "Add surround" },
      { "<leader>syw", desc = "word → (word)    [ysiw)]" },
      { "<leader>sy$", desc = "to $ → \"...\"    [ys$\"]" },

      { "<leader>sd", group = "Delete surround" },
      { "<leader>sd]", desc = "brackets []      [ds]]" },
      { "<leader>sdt", desc = "HTML tag         [dst]" },
      { "<leader>sdf", desc = "function call () [dsf]" },

      { "<leader>sc", group = "Change surround" },
      { "<leader>sc'", desc = "' → \"              [cs'\"]" },
      { "<leader>sct", desc = "<tag> → <h1>       [cst]" },

      --oil
      { "<leader>o", group = "Oil" },

      --treesitter-refactor
      { "<leader>r", group = "Treesitter-refactor"},
      { "<leader>rg", group = "Navigation"},
      { "<leader>rl", group = "List definition"},

      --gitsigns
      { "<leader>h", group = "gitsigns" },

      --aerial
      { "<leader>a", group = "aerial" },

      --trouble
      { "<leader>x", group = "Trouble" },
    })
  '';
}

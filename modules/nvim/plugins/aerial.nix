{
  programs.nixvim.plugins.aerial = {
    enable = true;
    fzf-lua.enable = true;
    lazyLoad.settings.keys = [ "<leader>a" ];
    luaConfig.post = ''
      require("aerial").setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
        backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
        layout = {
          min_width = 20,
        },
        filter_kind = false,
        autojump = true,
      })
      -- You probably also want to set a keymap to toggle aerial
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

      require("which-key").add({
        { "<leader>a", group = "aerial" }
      })
    '';
  };
}

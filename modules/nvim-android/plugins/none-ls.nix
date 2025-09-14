{
  programs.nixvim.plugins.lsp-format = {
    enable = true;
  };
  programs.nixvim.plugins.none-ls = {
    enable = true;
    enableLspFormat = true;
    lazyLoad = {
      enable = true;
      settings.event = [ "LspAttach" "BufWritePre" ];
    };
    settings = {
      border = "rounded";
      debug = false;
      diagnostic_config = {
        virtual_text = true;
        signs = true;
        update_in_insert = false;
        underline = true;
        severity_sort = true;
      };
      diagnostics_format = "[#{c}] #{m} (#{s})";
      fallback_severity = 2;
      log_level = "warn";
      notify_format = "[null-ls] %s";
      on_attach = null;
      on_exit = null;
      on_init = null;
      root_dir.__raw = ''
        require('null-ls.utils').root_pattern('.null-ls-root', '.git', 'Makefile')
      '';
      root_dir_async = null;
      should_attach = null;
      temp_dir = null;
      update_in_insert = false;
    };
    sources = {
      completion.luasnip.enable = true;
      diagnostics = {
        # yaml
        yamllint.enable = true;

        # nix
        deadnix.enable = true;
        statix.enable = true;

        # python
        mypy = {
          enable = false;
          settings.disabled_filetypes = [ "ipynb" ];
        };
        # cpp
        cppcheck.enable = true;

        # markdown
        markdownlint_cli2.enable = true;
        # dockerfile
        hadolint.enable = true;

        # sql
        sqlfluff.enable = true;
      };
      formatting = {
        # python
        black.enable = true;
        isort.enable = true;
        # markdown, javascript, css, dockerfile
        prettier.enable = true;
        # nix
        nixpkgs_fmt.enable = true;
        # cpp
        clang_format.enable = true;
        # shell
        shfmt.enable = true;
      };
    };
  };
}

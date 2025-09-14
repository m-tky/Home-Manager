{
  programs.nixvim = {
    plugins.treesitter-textobjects = {
      enable = true;
      move = {
        enable = true;
        setJumps = false;
        gotoNextStart = {
          "]b" = {
            query = "@code_cell.inner";
            desc = "next code block";
          };
        };
        gotoPreviousStart = {
          "[b" = {
            query = "@code_cell.inner";
            desc = "previous code block";
          };
        };
      };
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "ib" = {
            query = "@code_cell.inner";
            desc = "in block";
          };
          "ab" = {
            query = "@code_cell.outer";
            desc = "around block";
          };
        };
      };
      swap = {
        enable = true;
        swapNext = {
          "<leader>ml" = {
            query = "@code_cell.inner";
            desc = "swap next code block";
          };
        };
        swapPrevious = {
          "<leader>mh" = {
            query = "@code_cell.inner";
            desc = "swap previous code block";
          };
        };
      };
    };
  };

  xdg.configFile."nvim/after/queries/markdown/textobjects.scm".text = ''
    ;; extends

    (fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer
  '';
}

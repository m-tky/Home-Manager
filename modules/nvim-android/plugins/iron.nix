{
  programs.nixvim = {
    plugins.iron = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.ft = [ "python" ];
      };
      luaConfig.post = ''
        local iron = require("iron.core")

        local Terminal = require("toggleterm.terminal").Terminal

        local pyterm = Terminal:new({
          cmd = "python3",
          hidden = true,
          direction = "vertical",
          size = function(term)
            return math.floor(vim.o.columns * 0.35) -- 画面幅の40%
          end,
        })

        iron.setup({
          config = {
            scratch_repl = true,
            repl_definition = {
              sh = {
                command = function()
                  -- toggleterm ターミナルを開いて、その job_id を iron に渡す
                  pyterm:toggle()
                  return { bufnr = pyterm.bufnr }
                end,
              },
              python = {
                command = function()
                  pyterm:toggle()
                  return { bufnr = pyterm.bufnr }
                end,
                format = require("iron.fts.common").bracketed_paste_python,
                block_dividers = { "# %%", "#%%" },
                env = { PYTHON_BASIC_REPL = "1" },
              },
            },
            repl_filetype = function(bufnr, ft)
              return ft
            end,

            -- iron 側では repl_open_cmd をほぼ使わない（toggleterm が制御）
            repl_open_cmd = view.split.vertical.rightbelow("%35"),
          },
          -- If the highlight is on, you can change how it looks
          -- For the available options, check nvim_set_hl
          highlight = {
            italic = true,
          },
          ignore_blank_lines = true,
        })

        local core = require("iron.core")
        local marks = require("iron.marks")
        local visual_send_and_move_down = function()
          core.visual_send()
          vim.cmd("normal! j")
        end
        local line_send_and_move_down = function()
          core.send_line()
          vim.cmd("normal! j")
        end
    -- ここに上記のsetupの記述が入る。
        vim.keymap.set("n", "<leader>is", "<cmd>IronRepl<cr>", { desc = "Start Repl" })
        vim.keymap.set("n", "<leader>ir", "<cmd>IronRestart<cr>", { desc = "Restart Repl" })
        vim.keymap.set("n", "<leader>iF", "<cmd>IronFocus<cr>", { desc = "Focus Repl" })
        vim.keymap.set("n", "<leader>ih", "<cmd>IronHide<cr>", { desc = "Hide Repl" })
        vim.keymap.set("n", "<leader>ic", core.send_motion, { desc = "Send motion" })
        vim.keymap.set("n", "<leader>if", core.send_file, { desc = "Send file" })
        vim.keymap.set("n", "<leader>il", core.send_line, { desc = "Send line" })
        vim.keymap.set("n", "<C-CR>", line_send_and_move_down, { desc = "Send line" })
        vim.keymap.set("n", "<leader>ims", core.send_mark, { desc = "Mark send" })
        vim.keymap.set("n", "<leader>imc", core.mark_motion, { desc = "Mark motion" })
        vim.keymap.set("n", "<leader>iq", core.close_repl, { desc = "Exit" })
        vim.keymap.set("n", "<leader>imd", marks.drop_last, { desc = "Mark delete" })
        vim.keymap.set("n", "<leader>i<CR>", function()
          core.send(nil, string.char(13))
        end, { desc = "Carriage return" })
        vim.keymap.set("n", "<leader>i<space>", function()
          core.send(nil, string.char(03))
        end, { desc = "Interrupt" })
        vim.keymap.set("n", "<leader>ix", function()
          core.send(nil, string.char(12))
        end, { desc = "Clear" })
        vim.keymap.set("v", "<leader>ic", core.visual_send, { desc = "Send visual" })
        vim.keymap.set("v", "<C-CR>", visual_send_and_move_down, { desc = "Send visual" })
        vim.keymap.set("v", "<leader>imc", core.mark_visual, { desc = "Mark visual" })
      '';
    };
  };
}

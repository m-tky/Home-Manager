{
  programs.nixvim = {
    plugins.molten = {
      enable = true;

      # Configuration settings for molten.nvim. More examples at https://github.com/nix-community/nixvim/blob/main/plugins/by-name/molten/default.nix#L191
      settings = {
        auto_image_popup = false;
        auto_init_behavior = "init";
        auto_open_html_in_browser = false;
        auto_open_output = true;
        cover_empty_lines = false;
        copy_output = false;
        enter_output_behavior = "open_then_enter";
        image_provider = "image.nvim";
        output_crop_border = true;
        output_virt_lines = false;
        output_win_border = [
          ""
          "━"
          ""
          ""
        ];
        output_win_hide_on_leave = true;
        output_win_max_height = 15;
        output_win_max_width = 80;
        save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
        tick_rate = 500;
        use_border_highlights = false;
        limit_output_chars = 10000;
        wrap_output = true;
      };
    };
    keymaps = [
      {
        action = ":MoltenEvaluateOperator<CR>";
        key = "<leader>me";
        options = {
          desc = "evaluate operator";
          silent = true;
        };
      }
      {
        action = ":noautocmd MoltenEnterOutput<CR>";
        key = "<leader>mo";
        options = {
          desc = "open output window";
          silent = true;
        };
      }
      {
        action = ":MoltenReevaluateCell<CR>";
        key = "<leader>mr";
        options = {
          desc = "re-eval cell";
          silent = true;
        };
      }
      {
        action = ":<C-u>MoltenEvaluateVisual<CR>gv";
        key = "<leader>mv";
        options = {
          desc = "execute visual selection";
          silent = true;
        };
      }
      {
        action = ":MoltenHideOutput<CR>";
        key = "<leader>mh";
        options = {
          desc = "close output window";
          silent = true;
        };
      }
      {
        action = ":MoltenDelete<CR>";
        key = "<leader>md";
        options = {
          desc = "delete Molten cell";
          silent = true;
        };
      }
      {
        action = ":MoltenOpenInBrowser<CR>";
        key = "<leader>mx";
        options = {
          desc = "open output in browser";
          silent = true;
        };
      }
    ];
    extraConfigLua = ''
      require("which-key").add({
        { "<leader>m", group = "Molten" },
      })

      -- automatically import output chunks from a jupyter notebook
      -- tries to find a kernel that matches the kernel in the jupyter notebook
      -- falls back to a kernel that matches the name of the active venv (if any)
      local imb = function(e) -- init molten buffer
          vim.schedule(function()
              local kernels = vim.fn.MoltenAvailableKernels()
              local try_kernel_name = function()
                  local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
                  return metadata.kernelspec.name
              end
              local ok, kernel_name = pcall(try_kernel_name)
              if not ok or not vim.tbl_contains(kernels, kernel_name) then
                  kernel_name = nil
                  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
                  if venv ~= nil then
                      kernel_name = string.match(venv, "/.+/(.+)")
                  end
              end
              if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                  vim.cmd(("MoltenInit %s"):format(kernel_name))
              end
              vim.cmd("MoltenImportOutput")
          end)
      end

      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd("BufAdd", {
          pattern = { "*.ipynb" },
          callback = imb,
      })

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd("BufEnter", {
          pattern = { "*.ipynb" },
          callback = function(e)
              if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
                  imb(e)
              end
          end,
      })
      -- automatically export output chunks to a jupyter notebook on write
      vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.ipynb" },
          callback = function()
              if require("molten.status").initialized() == "Molten" then
                  vim.cmd("MoltenExportOutput!")
              end
          end,
      })

      local default_notebook = [[
        {
          "cells": [
           {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
              ""
            ]
           }
          ],
          "metadata": {
           "kernelspec": {
            "display_name": "Python 3",
            "language": "python",
            "name": "python3"
           },
           "language_info": {
            "codemirror_mode": {
              "name": "ipython"
            },
            "file_extension": ".py",
            "mimetype": "text/x-python",
            "name": "python",
            "nbconvert_exporter": "python",
            "pygments_lexer": "ipython3"
           }
          },
          "nbformat": 4,
          "nbformat_minor": 5
        }
      ]]

      local function new_notebook(filename)
        local path = filename .. ".ipynb"
        local file = io.open(path, "w")
        if file then
          file:write(default_notebook)
          file:close()
          vim.cmd("edit " .. path)
        else
          print("Error: Could not open new notebook file for writing.")
        end
      end

      vim.api.nvim_create_user_command('NewNotebook', function(opts)
        new_notebook(opts.args)
      end, {
        nargs = 1,
        complete = 'file'
      })
    '';
  };
}

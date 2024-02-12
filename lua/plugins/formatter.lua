return {
  "mhartington/formatter.nvim",
  event = "VeryLazy",
  config = function()
    local util = require("formatter.util")
    local defaults = require("formatter.defaults")
    local filetypes = require("formatter.filetypes")

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,

      filetype = {
        latex = filetypes.latex.latexindent,
        ruby = filetypes.ruby.rubocop,
        fish = filetypes.fish.fishindent,
        graphql = filetypes.graphql.prettierd,
        json = filetypes.json.prettierd,
        kotlin = filetypes.kotlin.ktlint,
        sh = filetypes.sh.shfmt,
        sql = filetypes.sql.pgformat,
        toml = filetypes.toml.taplo,
        yaml = filetypes.yaml.prettierd,
        zig = filetypes.zig.zigfmt,

        lua = {
          require("formatter.filetypes.lua").stylua,

          function()
            if util.get_current_buffer_file_name() == "special.lua" then
              return nil
            end

            return {
              exe = "stylua",
              args = {
                "--search-parent-directories",
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
                "--indent-type",
                "Spaces",
                "--indent-width",
                "2",
                "--",
                "-",
              },
              stdin = true,
            }
          end,
        },

        c = {
          function()
            return {
              exe = "clang-format",
              args = {
                "-assume-filename",
                util.escape_path(util.get_current_buffer_file_name()),
                "--style",
                "file:" .. vim.env.HOME .. "/.vim/configs/.clang-format",
              },
              stdin = true,
              try_node_modules = true,
            }
          end,
        },

        cpp = {
          function()
            return {
              exe = "clang-format",
              args = {
                "-assume-filename",
                util.escape_path(util.get_current_buffer_file_name()),
                "--style",
                "file:" .. vim.env.HOME .. "/.vim/configs/.clang-format",
              },
              stdin = true,
              try_node_modules = true,
            }
          end,
        },

        java = {
          function()
            return {
              exe = "clang-format",
              args = { "--style=Chromium", "--assume-filename=.java" },
              stdin = true,
            }
          end,
        },
      },
    })

    vim.api.nvim_create_augroup("Formatter", {})

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = "Formatter",
      pattern = "*",
      command = "FormatWrite",
      desc = "Format code on write",
    })
  end,
}

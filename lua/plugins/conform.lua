return {
  "stevearc/conform.nvim",
  -- enabled = false,
  event = "VeryLazy",
  config = function()
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })

    require("conform").setup({
      formatters_by_ft = {
        bash = { lsp_format = "fallback" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        fish = { "fish_indent" },
        graphql = { "prettierd" },
        html = { "prettierd" },
        javascript = { "biome-check" },
        javascriptreact = { "biome-check" },
        json = { "biome-check", stop_after_first = true },
        jsonc = { "biome-check", stop_after_first = true },
        kotlin = { "ktlint" },
        latex = { "latexindent" },
        lua = { "stylua" },
        scss = { "prettierd" },
        sh = { "shfmt" },
        sql = { "sqlfluff" },
        tex = { "latexindent" },
        typescript = { "biome-check" },
        typescriptreact = { "biome-check" },
        typst = { "typstyle" },
        toml = { "taplo" },
        uiua = { "uiua" },
        yaml = { "prettierd" },
        zig = { "zigfmt" },
      },

      formatters = {
        ["clang-format"] = {
          args = {
            "-assume-filename",
            "$FILENAME",
            "--style",
            "file:" .. vim.env.HOME .. "/.vim/configs/.clang-format",
          },
        },

        sqlfluff = {
          args = {
            "format",
            "--dialect",
            "postgres",
            "--disable-progress-bar",
            "--nocolor",
            "-",
          },
          require_cwd = false,
          exit_codes = { 0, 1 },
        },

        stylua = {
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            "$FILENAME",
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--collapse-simple-statement",
            "Always",
            "--",
            "-",
          },
        },

        typstyle = {
          args = {
            "--wrap-text",
          },
        },

        uiua = {
          command = "uiua",
          args = {
            "fmt",
            "--io",
            "$FILENAME",
          },
        },
      },

      default_format_opts = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return {}
      end,
    })
  end,
}

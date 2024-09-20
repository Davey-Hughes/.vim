return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        fish = { "fish_indent" },
        graphql = { "prettierd" },
        json = { "prettierd", "prettier", stop_after_first = true },
        kotlin = { "ktlint" },
        latex = { "latexindent" },
        lua = { "stylua" },
        sh = { "shfmt" },
        sql = { "sqlfluff" },
        tex = { "latexindent" },
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
            "--",
            "-",
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

      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",

    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = {
          "bash",
          "c",
          "go",
          "javascript",
          "json",
          "latex",
          "lua",
          "python",
          "rust",
          "typescript",
          "vim",
        },

        sync_install = false,
        auto_install = true,
        ignore_install = {},

        indent = {
          enable = true,
          disable = { "javascript" },
        },

        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = { "markdown" },
        },
      })
    end,
  },

  {
    "RRethy/nvim-treesitter-endwise",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
      })
    end,
  },
}

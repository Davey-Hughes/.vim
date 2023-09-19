return {
  {
    "nvim-treesitter/nvim-treesitter",

    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = { "c", "lua", "rust", "python", "javascript", "go", "vim", "bash", "latex", "json" },

        sync_install = false,
        auto_install = true,
        ignore_install = {},

        indent = {
          enable = true,
        },

        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
      })
    end,
  },
}

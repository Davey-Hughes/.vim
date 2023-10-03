return {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "linrongbin16/lsp-progress.nvim",
      config = function()
        require("lsp-progress").setup()
      end,
    },
  },

  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename", require("lsp-progress").progress },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })

    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
      group = "lualine_augroup",
      callback = require("lualine").refresh,
    })
  end,
}

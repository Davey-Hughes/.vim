return {
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        numbers = "ordinal",
        always_show_bufferline = false,
        tab_size = 10,
        modified_icon = "●",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "franco-ruggeri/codecompanion-lualine.nvim",
    },

    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",

          ignore_focus = {
            "dapui_watches",
            "dapui_breakpoints",
            "dapui_scopes",
            "dapui_console",
            "dapui_stacks",
            "dap-repl",
          },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 3 } },
          lualine_x = { { "codecompanion", icon = "󰳆" }, "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 3 } },
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
    end,
  },
}

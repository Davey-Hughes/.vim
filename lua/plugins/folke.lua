return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      { "rcarriga/nvim-notify" },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("notify").setup({
        timeout = 500,
        stages = "fade_in_slide_out",
      })

      require("noice").setup({
        views = {
          cmdline = {
            border = {
              style = "none",
            },
          },
        },
        cmdline = {
          view = "cmdline",
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              kind = "echomsg",
              find = "vim.deprecated",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d fewer lines" },
                { find = "%d more lines" },
                { find = "%d lines <ed %d time[s]?" },
                { find = "%d lines >ed %d time[s]?" },
                { find = "%d lines yanked" },
              },
            },
            view = "mini",
          },
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },

          hover = {
            enabled = false,
          },

          signature = {
            enabled = false,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = false,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    cmd = "Trouble",
    opts = {},
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tT",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  { "folke/twilight.nvim", event = "VeryLazy" },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
}

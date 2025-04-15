return {
  { "Bekaboo/deadcolumn.nvim" },
  { "Eandrju/cellular-automaton.nvim", event = "VeryLazy" },
  { "RRethy/vim-illuminate", event = "VeryLazy" },
  { "kevinhwang91/nvim-hlslens", opts = {} },
  { "mcauley-penney/tidy.nvim", opts = { filetype_exclude = { "markdown", "diff" } } },
  { "michaelb/sniprun", event = "VeryLazy", build = "sh ./install.sh" },
  { "nvim-tree/nvim-web-devicons" },
  { "sitiom/nvim-numbertoggle", event = "VeryLazy" },
  { "tpope/vim-abolish" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-speeddating", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function() require("nvim-surround").setup({}) end,
  },
  { "ZWindL/orphans.nvim", opts = {} },

  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },

  {
    "rmagatti/auto-session",
    event = "VimEnter",
    opts = {
      log_level = "error",

      suppressed_dirs = { "~/", "~/projects", "~/Downloads", "/" },
      bypass_save_filetypes = { "snacks_dashboard" },

      auto_save = true,
      auto_restore = true,

      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    },
  },

  {
    "rmagatti/goto-preview",
    event = "VeryLazy",
    config = function()
      require("goto-preview").setup({
        default_mappings = true,
        width = 120,
        height = 80,
      })
    end,
  },

  {
    "mbbill/undotree",
    event = "VeryLazy",
    keys = {
      { "<F5>", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undo Tree" } },
    },
  },

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
    "p00f/godbolt.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("godbolt").setup({
        language = {
          c = {
            compiler = "cclang1600",
          },
          cpp = {
            compiler = "cclang1600",
          },
          rust = {
            compiler = "beta",
          },
          go = {
            compiler = "gccgo132",
          },
          python = {
            compiler = "python311",
          },
          java = {
            compiler = "java2000",
          },
          kotlin = {
            compiler = "kotlinc1900",
          },
          javascript = {
            compiler = "v8trunk",
          },
          haskell = {
            compiler = "ghc961",
          },
          zig = {
            compiler = "ztrunk",
          },
        },
      })
    end,

    keys = {
      { "<leader>gb", "<cmd>Godbolt!<cr>", { desc = "Godbolt" }, mode = "v" },
      { "<leader>gc", "<cmd>GodboltCompiler! telescope", { desc = "Godbolt Compiler in Telescope" }, mode = "v" },
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function() require("colorizer").setup({}) end,
  },

  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    config = true,
    keys = {
      { "-", "<cmd>Oil --float<CR>", { desc = "Open parent directory" } },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    priority = -1000, -- ensure this loads last
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },

    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("Comment").setup({
        toggler = {
          line = "<leader>c<leader>",
          block = "<leader>cb",
        },
        opleader = {
          line = "<leader>c<leader>",
          block = "<leader>b<leader>",
        },
        extra = {
          above = "<leader>cO",
          below = "<leader>co",
          eol = "<leader>cA",
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })

      local ft = require("Comment.ft")

      ft.pest = { "//%s", "/*%s*/" }
    end,
  },

  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    opts = {
      disable_when_zoomed = true,
    },
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true,
      })

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
    end,
  },

  {
    "Goose97/timber.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function() require("timber").setup({}) end,
  },

  {
    "MagicDuck/grug-far.nvim",
    opts = {},
  },
}

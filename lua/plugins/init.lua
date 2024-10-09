return {
  -- misc
  { "Eandrju/cellular-automaton.nvim", event = "VeryLazy" },
  {
    "glacambre/firenvim",
    -- Lazy load firenvim
    lazy = not vim.g.started_by_firenvim,
    enabled = false,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },
  {
    "michaelb/sniprun",
    event = "VeryLazy",
    build = "sh ./install.sh",
  },

  { "nanotee/zoxide.vim", event = "VeryLazy" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-abolish" },
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",

      suppressed_dirs = { "~/", "~/projects", "~/Downloads", "/" },

      auto_save_enabled = true,
      auto_restore_enabled = true,

      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    },
  },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local harpoon = require("harpoon")
      ---@diagnostic disable-next-line: missing-fields
      harpoon.setup({
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
      })

      vim.keymap.set("n", "<leader>hm", function()
        harpoon:list():append()
      end)

      vim.keymap.set("n", "<leader>hn", function()
        harpoon:list():prev()
      end)
      vim.keymap.set("n", "<leader>hp", function()
        harpoon:list():prev()
      end)
    end,
  },

  -- ui
  {
    "ipod825/vim-tabdrop",
    event = "VeryLazy",
  },

  {
    "liuchengxu/vista.vim",
    event = "VeryLazy",
    config = function()
      vim.g.vista_icon_indent = '["╰─▸ ", "├─▸ "]'
      vim.g["vista#renderer#enable_icon"] = 1
      vim.g.vista_stay_on_open = 0
      vim.cmd([[
        " close vista if the last buffer is closed
        augroup vista
            autocmd!
            autocmd bufenter *
                \ if winnr("$") == 1 && vista#sidebar#IsOpen() |
                    \ execute "normal! :q!\<CR>" |
                \ endif
        augroup END

        nnoremap <F10> :Vista!!<CR>
      ]])
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
    "crispgm/nvim-tabline",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional
    config = function()
      require("tabline").setup({
        show_icon = true,
        brackets = { "", "" },
      })
    end,
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
    "Davey-Hughes/dashboard-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      config = {
        shortcut = {
          { desc = "󰊳 LazyUpdate", group = "@property", action = "Lazy update", key = "u" },
          { desc = "󰊳 TSUpdate", group = "@property", action = "TSUpdate", key = "t" },
          { desc = "Close", group = "@property", action = "bdelete", key = "q", hide = true },
        },
        week_header = {
          enable = true,
        },
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
  { "RRethy/vim-illuminate", event = "VeryLazy" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({})
    end,
  },
  { "sitiom/nvim-numbertoggle", event = "VeryLazy" },
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

  -- text editing
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
    end,
  },
  {
    "mcauley-penney/tidy.nvim",
    opts = {
      filetype_exclude = { "markdown", "diff" },
    },
  },
  { "Bekaboo/deadcolumn.nvim" },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    priority = -1000, -- ensure this loads last

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
      })

      local ft = require("Comment.ft")

      ft.pest = { "//%s", "/*%s*/" }
    end,
  },

  { "tpope/vim-speeddating", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },

  -- tmux
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
}

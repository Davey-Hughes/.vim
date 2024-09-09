return {
  -- filetype
  { "apple/pkl-neovim", ft = "pkl" },
  { "bfrg/vim-cpp-modern", ft = "cpp" },
  { "chrisbra/csv.vim", ft = "csv" },
  { "leafgarland/typescript-vim", ft = "typescript" },
  { "maxbane/vim-asm_ca65", ft = "ca65" },
  { "PyGamer0/vim-apl", ft = "apl" },
  { "rust-lang/rust.vim", ft = "rust" },
  { "udalov/kotlin-vim", ft = "kotlin" },
  { "vim-ruby/vim-ruby", ft = "ruby" },

  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_view_general_viewer = "okular"
      vim.g.vimtex_syntax_enabled = false
      vim.g.vimtex_format_enabled = true
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

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

      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

      auto_save_enabled = true,
      auto_restore_enabled = true,

      session_lens = {
        buftypes_to_ignore = {},
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

  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        "hrsh7th/nvim-cmp",
      },
    },
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true, auto_trigger = false },
        panel = { enabled = false },
      })

      require("copilot_cmp").setup()
    end,
  },

  -- ui
  {
    "folke/noice.nvim",
    version = "4.4.7",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
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
        "<leader>tx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tX",
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
        "<leader>tQ",
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
  {
    "ipod825/vim-tabdrop",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        nnoremap <C-]> :TagTabdrop<CR>
        vnoremap <C-]> <Esc>:TagTabdrop<CR>
      ]])
    end,
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
    config = function()
      vim.cmd([[
        nnoremap <F5> :UndotreeToggle<CR>
    ]])
    end,
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

      vim.cmd([[
        vnoremap <leader>gb :Godbolt<CR>
        vnoremap <leader>gc :GodboltCompiler telescope<CR>
      ]])
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("dashboard").setup({})
    end,
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
      require("colorizer").setup()
    end,
  },
  { "sitiom/nvim-numbertoggle", event = "VeryLazy" },

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
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    priority = -1000, -- ensure this loads last

    config = function()
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

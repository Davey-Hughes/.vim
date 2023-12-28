return {
  -- filetype
  { "bfrg/vim-cpp-modern", ft = "cpp" },
  { "chrisbra/csv.vim", ft = "csv" },
  { "ehamberg/vim-cute-python", ft = "python" },
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
      vim.g.vimtex_latexmk_callback = 0
      vim.g.vimtext_compiler_latexmk = "{'callback' : 0}"
    end,
  },

  -- misc
  {
    "bennypowers/nvim-regexplainer",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("regexplainer").setup()
    end,
  },
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
    "michaelb/sniprun",
    event = "VeryLazy",
    build = "sh ./install.sh",
  },

  { "nanotee/zoxide.vim", event = "VeryLazy" },
  "tpope/vim-sleuth",

  {
    "olimorris/persisted.nvim",
    opts = {
      autosave = true,
      autoload = true,
    },
  },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("harpoon").setup({
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
      })

      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      vim.keymap.set("n", "<leader>hm", mark.add_file, {})
      vim.keymap.set("n", "<leader>hn", ui.nav_next, {})
      vim.keymap.set("n", "<leader>hp", ui.nav_prev, {})
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    cond = false,
    dependencies = {
      { "zbirenbaum/copilot-cmp" },
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
    event = "VeryLazy",
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
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "folke/twilight.nvim", event = "VeryLazy" },
  {
    "gelguy/wilder.nvim",
    event = "VeryLazy",
    build = ":UpdateRemotePlugins",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })

      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline({
            fuzzy = 1,
            set_pcre2_pattern = 1,
          }),
          wilder.python_search_pipeline({
            pattern = "fuzzy",
          })
        ),
      })

      local highlighters = {
        wilder.pcre2_highlighter(),
        wilder.basic_highlighter(),
      }

      wilder.set_option(
        "renderer",
        wilder.renderer_mux({
          [":"] = wilder.wildmenu_renderer({
            highlighter = highlighters,
          }),
          ["/"] = wilder.wildmenu_renderer({
            highlighter = highlighters,
          }),
        })
      )
    end,
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
    nnoremap <F4> :UndotreeToggle<CR>
    ]])
    end,
  },

  "mkitt/tabline.vim",
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
    event = "VeryLazy",
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
  "nvim-tree/nvim-web-devicons",
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
    "ntpeters/vim-better-whitespace",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        " blacklist
        let g:better_whitespace_filetypes_blacklist=[
            \ 'go', 'diff', 'gitcommit', 'unite', 'qf', 'help'
        \ ]

        let g:better_whitespace_enabled=0
        let g:strip_whitespace_on_save=1
        let g:strip_whitespace_confirm=0

        augroup better-whitespace
            autocmd!
            autocmd FileType markdown let b:strip_whitespace_on_save=0
        augroup END
      ]])
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    priority = -1000, -- ensure this loads last
    opts = {
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
    },
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

return {
  -- filetype
  { "bfrg/vim-cpp-modern", ft = "cpp" },
  { "chrisbra/csv.vim", ft = "csv" },
  { "ehamberg/vim-cute-python", ft = "python" },
  { "fatih/vim-go", ft = "go" },
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("regexplainer").setup()
    end,
  },
  "Eandrju/cellular-automaton.nvim",
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
    build = "sh ./install.sh",
  },

  "nanotee/zoxide.vim",
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
  "folke/twilight.nvim",
  {
    "gelguy/wilder.nvim",
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
    config = function()
      vim.cmd([[
        nnoremap <C-]> :TagTabdrop<CR>
        vnoremap <C-]> <Esc>:TagTabdrop<CR>
      ]])
    end,
  },

  {
    "liuchengxu/vista.vim",
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
    config = function()
      vim.cmd([[
    nnoremap <F4> :UndotreeToggle<CR>
    ]])
    end,
  },

  "mkitt/tabline.vim",
  {
    "p00f/godbolt.nvim",
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
    event = "VimEnter",
    config = function()
      require("dashboard").setup({})
    end,
  },

  "rcarriga/nvim-notify",
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({
        default_mappings = true,
      })
    end,
  },
  "RRethy/vim-illuminate",
  "nvim-tree/nvim-web-devicons",
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  "sitiom/nvim-numbertoggle",

  -- text editing
  {
    "ntpeters/vim-better-whitespace",
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
    lazy = false,
  },

  "tpope/vim-speeddating",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",

  -- tmux
  {
    "alexghergh/nvim-tmux-navigation",
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
  "tmux-plugins/vim-tmux-focus-events",
}

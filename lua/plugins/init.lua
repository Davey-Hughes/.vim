return {
  -- colorscheme
  {
    "Davey-Hughes/NeoSolarized",
    priority = 1000,
    config = function()
      vim.opt.background = "dark"
      vim.opt.termguicolors = true
      vim.g.neosolarized_patched = 1
      vim.cmd [[
        colorscheme NeoSolarized

        " make split indicator look thinner
        highlight VertSplit ctermbg=NONE
        highlight VertSplit guibg=NONE

        " make SignColumn the same color as the line number column
        highlight! link SignColumn LineNr
      ]]
    end,
  },

  -- filetype
  { "bfrg/vim-cpp-modern", ft = "cpp" },
  { "chrisbra/csv.vim", ft = "csv" },
  { "ehamberg/vim-cute-python", ft = "python" },
  { "fatih/vim-go", ft = "go" },
  { "kchmck/vim-coffee-script", ft = "coffee" },
  { "leafgarland/typescript-vim", ft = "typescript" },

  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.vimtex_latexmk_callback = 0
      vim.g.vimtext_compiler_latexmk = "{'callback' : 0}"
    end,
  },

  { "maxbane/vim-asm_ca65", ft = "ca65" },
  { "nickeb96/fish.vim", ft = "fish" },
  { "PyGamer0/vim-apl", ft = "apl" },
  { "rust-lang/rust.vim", ft = "rust" },
  { "udalov/kotlin-vim", ft = "kotlin" },
  { "vim-ruby/vim-ruby", ft = "ruby" },

  -- formatters
  { "prettier/vim-prettier", ft = "javascript" },
  { "rhysd/vim-clang-format", ft = { "c", "cpp" } },
  { "tell-k/vim-autopep8", ft = "python" },

  {
    "wesleimp/stylua.nvim",
    ft = "lua",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.g.stylua,
        pattern = { "*.lua" },
        callback = function(args)
          local stylua_path = vim.fn.expand "$HOME/.vim/configs/" .. "stylua.toml"
          require("stylua").format { config_path = stylua_path }
        end,
      })
    end,
  },

  -- git
  "rbong/vim-flog",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- misc
  "tpope/vim-sleuth",

  {
    "dhruvasagar/vim-prosession",
    dependencies = {
      "tpope/vim-obsession",
    },
    init = function()
      vim.g.prosession_dir = "~/.vim/local/sessions/"
    end,
  },

  {
    "glacambre/firenvim",
    -- Lazy load firenvim
    lazy = not vim.g.started_by_firenvim,
    enabled = false,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },

  -- ui
  {
    "ipod825/vim-tabdrop",
    config = function()
      vim.cmd [[
        nnoremap <C-]> :TagTabdrop<CR>
        vnoremap <C-]> <Esc>:TagTabdrop<CR>
      ]]
    end,
  },

  {
    "liuchengxu/vista.vim",
    config = function()
      vim.g.vista_icon_indent = '["╰─▸ ", "├─▸ "]'
      vim.g["vista#renderer#enable_icon"] = 1
      vim.g.vista_stay_on_open = 0
      vim.cmd [[
        " close vista if the last buffer is closed
        augroup vista
            autocmd!
            autocmd bufenter *
                \ if winnr("$") == 1 && vista#sidebar#IsOpen() |
                    \ execute "normal! :q!\<CR>" |
                \ endif
        augroup END

        nnoremap <F10> :Vista!!<CR>
      ]]
    end,
  },

  {
    "mbbill/undotree",
    config = function()
      vim.cmd [[
    nnoremap <F4> :UndotreeToggle<CR>
    ]]
    end,
  },

  "mkitt/tabline.vim",
  "rcarriga/nvim-notify",
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup {
        default_mappings = true,
      }
    end,
  },
  "ryanoasis/vim-devicons",
  "sitiom/nvim-numbertoggle",

  -- text editing
  {
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.cmd [[
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
      ]]
    end,
  },

  {
    "scrooloose/nerdcommenter",
    priority = -1000, -- ensure this loads last
    config = function()
      vim.g.NERDSpaceDelims = 1
      vim.cmd [[
      let g:NERDCustomDelimiters={
          \ 'python': {'left': '#', 'leftAlt': '#'},
          \ 'c': {'left': '/*', 'leftAlt': '//', 'right': '*/', 'rightAlt': ''}
      \ }
    ]]
    end,
  },
  "tpope/vim-speeddating",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",

  -- tmux
  "christoomey/vim-tmux-navigator",
  "tmux-plugins/vim-tmux-focus-events",
}

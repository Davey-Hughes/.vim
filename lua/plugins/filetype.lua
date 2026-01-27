return {
  { "apple/pkl-neovim", ft = "pkl" },
  { "bfrg/vim-cpp-modern", ft = "cpp" },
  { "maxbane/vim-asm_ca65", ft = "ca65" },
  { "PyGamer0/vim-apl", ft = "apl" },
  { "rust-lang/rust.vim", ft = "rust" },
  { "udalov/kotlin-vim", ft = "kotlin" },
  { "vim-ruby/vim-ruby", ft = "ruby" },
  { "ziglang/zig.vim", ft = "zig" },

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
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  },

  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
}

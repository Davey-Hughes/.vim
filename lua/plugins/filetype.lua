return {
  { "apple/pkl-neovim", ft = "pkl" },
  { "bfrg/vim-cpp-modern", ft = "cpp" },
  { "chrisbra/csv.vim", ft = "csv" },
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
}

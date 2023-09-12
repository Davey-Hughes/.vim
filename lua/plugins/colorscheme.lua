return {
  -- colorscheme
  {
    "Davey-Hughes/NeoSolarized",
    priority = 1000,
    cond = false,
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

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    cond = true,
    config = function()
      vim.cmd [[
        colorscheme tokyonight-moon

        " make SignColumn the same color as the line number column
        highlight! link SignColumn LineNr
        highlight! link DiffAdd LineNr
        highlight! link DiffChange LineNr
        highlight! link DiffDelete LineNr
        highlight! link DiffText LineNr
      ]]
    end,
  },
}

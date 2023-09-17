return {
  -- colorscheme
  {
    "Davey-Hughes/NeoSolarized",
    priority = 1000,
    cond = (vim.env.COLORSCHEME == "neosolarized"),
    config = function()
      vim.opt.background = "dark"
      if vim.env.COLORSCHEME_VARIANT == "light" then
        vim.opt.background = "dark"
      end

      vim.opt.termguicolors = true
      vim.g.neosolarized_patched = 1
      vim.cmd([[
        colorscheme NeoSolarized

        " make split indicator look thinner
        highlight VertSplit ctermbg=NONE
        highlight VertSplit guibg=NONE

        " make SignColumn the same color as the line number column
        highlight! link SignColumn LineNr
      ]])
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    cond = (vim.env.COLORSCHEME == "tokyonight"),
    config = function()
      require("tokyonight").setup({
        on_colors = function(colors)
          colors.hint = colors.fg_gutter
        end,
      })

      -- tokyonight-moon is the default
      vim.cmd([[colorscheme tokyonight-moon]])

      if vim.env.COLORSCHEME_VARIANT == "night" then
        vim.cmd([[colorscheme tokyonight-night]])
      elseif vim.env.COLORSCHEME_VARIANT == "storm" then
        vim.cmd([[colorscheme tokyonight-storm]])
      elseif vim.env.COLORSCHEME_VARIANT == "day" then
        vim.cmd([[colorscheme tokyonight-day]])
      end

      vim.cmd([[
        " make SignColumn the same color as the line number column
        highlight! link SignColumn LineNr
        highlight! link DiffAdd LineNr
        highlight! link DiffChange LineNr
        highlight! link DiffDelete LineNr
        highlight! link DiffText LineNr
      ]])
    end,
  },
}

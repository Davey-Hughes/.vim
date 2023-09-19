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
          local util = require("tokyonight.util")
          colors.hint = colors.fg_gutter
          --   colors.diff = {
          colors.diff = {
            add = util.darken(colors.green2, 0.20),
            delete = util.darken(colors.red1, 0.30),
            change = util.darken(colors.blue7, 0.10),
            text = colors.blue7,
          }
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
    end,
  },
}

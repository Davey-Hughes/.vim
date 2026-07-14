---@module "vectorcode"

return {
  {
    "supermaven-inc/supermaven-nvim",
    enabled = true,
    config = function()
      require("supermaven-nvim").setup({
        ignore_filetypes = {},
        log_level = "off",
        disable_inline_completion = true,
        disable_keymaps = true,
      })
    end,
  },
}

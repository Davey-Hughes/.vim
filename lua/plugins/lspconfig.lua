return {
  "neovim/nvim-lspconfig",

  config = function()
    require("lspconfig").pyright.setup {}
    require("lspconfig").ccls.setup {}

    vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float)
    vim.keymap.set("n", "<leader>l[", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<leader>l]", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist)
  end,
}

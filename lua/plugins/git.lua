return {
  { "rbong/vim-flog", event = "VeryLazy" },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "tpope/vim-rhubarb", event = "VeryLazy" },

  {
    "kdheepak/lazygit.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", nil)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    -- event = "VeryLazy",
    config = function()
      require("gitsigns").setup({})
    end,
  },
}

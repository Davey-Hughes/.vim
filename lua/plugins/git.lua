return {
  "rbong/vim-flog",
  "tpope/vim-fugitive",
  {
    "tpope/vim-rhubarb",
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      vim.opt.fillchars:append({ diff = "╱" })
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", nil)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
}

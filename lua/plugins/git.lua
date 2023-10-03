return {
  { "rbong/vim-flog", event = "VeryLazy" },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "tpope/vim-rhubarb", event = "VeryLazy" },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      vim.opt.fillchars:append({ diff = "╱" })
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    version = "*",
    config = true,
  },
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
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup()
    end,
  },
}

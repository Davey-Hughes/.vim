return {
  {
    "kdheepak/lazygit.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function() vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", nil) end,
  },

  {
    "swaits/lazyjj.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      mapping = "<leader>jj",
    },
  },

  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      graph_style = "kitty",
      disable_hint = true,
    },
    keys = {
      { "<leader>ng", "<cmd>Neogit<cr>", desc = "Open neogit" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function() require("gitsigns").setup({}) end,
    keys = {
      { "<leader>gs", "<cmd>Gitsigns blame<cr>", desc = "Toggle git signs" },
    },
  },
}

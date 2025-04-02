return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/main/**.md",
    "BufNewfile " .. vim.fn.expand("~") .. "/obsidian/main/**.md",
  },

  opts = {
    dir = "~/obsidian/main",
    completion = {
      nvim_cmp = true,
      min_chars = 2,
      new_notes_location = "current_dir",
      prepend_note_id = true,
    },
    mappings = {
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },

    finder = "telescope.nvim",
  },
}

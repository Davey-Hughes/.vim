return {
  "epwalsh/obsidian.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/main/**.md",
    "BufNewfile " .. vim.fn.expand("~") .. "/obsidian/main/**.md",
  },

  config = function()
    require("obsidian").setup({
      dir = "~/obsidian/main",
      completion = {
        nvim_cmp = false,
        min_chars = 2,
        new_notes_location = "current_dir",
        prepend_note_id = true,
      },
      mappings = {
        ["gf"] = require("obsidian.mapping").gf_passthrough(),
      },

      finder = "telescope.nvim",
    })
  end,
}

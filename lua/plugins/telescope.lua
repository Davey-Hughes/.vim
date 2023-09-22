return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "BurntSushi/ripgrep",
    "sharkdp/fd",
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local fb_actions = require("telescope").extensions.file_browser.actions

    require("telescope").setup({

      defaults = {
        path_display = { "smart" },

        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").cycle_history_next,
            ["<C-k>"] = require("telescope.actions").cycle_history_prev,
          },
        },

        history = {
          path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3",
          limit = 100,
        },
      },

      extensions = {
        persisted = {
          layout_config = { width = 0.55, height = 0.55 },
        },

        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
          mappings = {
            ["n"] = {
              ["c"] = fb_actions.create,
            },
          },
        },
      },
    })

    require("telescope").load_extension("persisted")
    require("telescope").load_extension("smart_history")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
    local harpoon = require("telescope").load_extension("harpoon")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<c-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>fm", builtin.man_pages, {})
    vim.keymap.set("n", "<leader>fr", builtin.registers, {})
    vim.keymap.set("n", "<leader>fc", builtin.commands, {})
    vim.keymap.set("n", "<leader>fl", builtin.lsp_dynamic_workspace_symbols, {})
    vim.keymap.set("n", "<space>fe", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>fm", harpoon.marks, {})
  end,
}

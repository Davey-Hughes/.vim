return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
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
    "nvim-telescope/telescope-live-grep-args.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    local ts_select_dir_for_grep_args = function(prompt_bufnr)
      local action_state = require("telescope.actions.state")
      local fb = require("telescope").extensions.file_browser
      local lga = require("telescope").extensions.live_grep_args
      local current_line = action_state.get_current_line()

      fb.file_browser({
        files = false,
        depth = false,
        attach_mappings = function(prompt_bufnr)
          require("telescope.actions").select_default:replace(function()
            local entry_path = action_state.get_selected_entry().Path
            local dir = entry_path:is_dir() and entry_path or entry_path:parent()
            local relative = dir:make_relative(vim.fn.getcwd())
            local absolute = dir:absolute()

            lga.live_grep_args({
              results_title = relative .. "/",
              cwd = absolute,
              default_text = current_line,
            })
          end)

          return true
        end,
      })
    end

    local fb_actions = require("telescope").extensions.file_browser.actions
    local lga_actions = require("telescope-live-grep-args.actions")

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

      pickers = {},

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

        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-f>"] = ts_select_dir_for_grep_args,
            },
            n = {
              ["<C-f>"] = ts_select_dir_for_grep_args,
            },
          },
        },
      },
    })

    require("telescope").load_extension("persisted")
    require("telescope").load_extension("smart_history")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
    local lga = require("telescope").load_extension("live_grep_args")
    local harpoon = require("telescope").load_extension("harpoon")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<c-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fa", lga.live_grep_args, {})
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>fm", builtin.man_pages, {})
    vim.keymap.set("n", "<leader>fr", builtin.registers, {})
    vim.keymap.set("n", "<leader>fc", builtin.commands, {})
    vim.keymap.set("n", "<leader>fl", builtin.lsp_dynamic_workspace_symbols, {})
    vim.keymap.set("n", "<space>fe", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
    vim.keymap.set("n", "<leader>fm", harpoon.marks, {})
    vim.keymap.set("n", "<leader>fn", ":Noice telescope<CR>", {})
  end,
}

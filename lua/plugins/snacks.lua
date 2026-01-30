---@module "snacks"

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      debug = { enabled = true },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      lazygit = { enabled = true },
      image = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      picker = {
        layout = { preset = "telescope" },
        sources = {
          explorer = {
            replace_netrw = true,
            auto_close = true,
            layout = { preset = "ivy", position = "bottom", preview = true },
            win = {
              list = {
                keys = {
                  ["<c-t>"] = { "tab", mode = { "n", "i" } },
                },
              },
            },
          },

          files = {
            hidden = true,
          },

          -- combination grep and files picker
          combo = {
            picker = "combo",
            multi = { "grep", "files" },
            regex = "true",
            format = "file",
            show_empty = true,
            live = true,
            supports_live = true,
            hidden = true,
            follow = false,
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      terminal = { enabled = true },
      togggle = { enabled = true },
      words = { enabled = true },
    },

    keys = {
      { "<leader>fe", function() Snacks.explorer() end, desc = "Explorer" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Open lazygit" },

      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>ft", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>fm", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>fr", function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>fl", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      { "<leader>fn", function() Snacks.picker.noice() end, desc = "Noice History" },
      { "<leader>f<space>", function() Snacks.picker.combo() end, desc = "Combination Picker" },

      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },

      { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    },
  },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>hm", function() harpoon:list():add() end, { desc = "Harpoon Add" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon Next" })
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon Prev" })
      vim.keymap.set(
        "n",
        "<C-e>",
        function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon Quick Menu" }
      )

      -- picker
      local normalize_list = function(t)
        local normalized = {}
        for _, v in pairs(t) do
          if v ~= nil then table.insert(normalized, v) end
        end
        return normalized
      end

      vim.keymap.set("n", "<leader>fh", function()
        Snacks.picker({
          finder = function()
            local file_paths = {}
            local list = normalize_list(harpoon:list().items)
            for _, item in ipairs(list) do
              table.insert(file_paths, { text = item.value, file = item.value })
            end
            return file_paths
          end,
          win = {
            input = {
              keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
            },
            list = {
              keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
            },
          },
          actions = {
            harpoon_delete = function(picker, item)
              local to_remove = item or picker:selected()
              harpoon:list():remove({ value = to_remove.text })
              harpoon:list().items = normalize_list(harpoon:list().items)
              picker:find({ refresh = true })
            end,
          },
        })
      end, { desc = "Harpoon" })
    end,
  },
}

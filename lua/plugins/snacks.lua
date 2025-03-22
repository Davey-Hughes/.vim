---@module "snacks"

return {
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
    explorer = {
      enabled = true,
      -- layout = { preset = "ivy", position = "bottom" },
    },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    lazygit = { enabled = false },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      layout = {
        reverse = true,
        layout = {
          box = "horizontal",
          backdrop = false,
          width = 0.8,
          height = 0.9,
          border = "none",
          {
            box = "vertical",
            { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
            { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
          },
          {
            win = "preview",
            title = "{preview:Preview}",
            width = 0.45,
            border = "rounded",
            title_pos = "center",
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    -- statuscolumn = { enabled = true },
    togggle = { enabled = true },
    words = { enabled = true },
  },

  -- vim.keymap.set("n", "<space>fe", function()
  --   fb.file_browser({ path = "%:p:h", select_buffer = true, hidden = true })
  -- end, { noremap = true, desc = "Telescope file browser" })
  -- vim.keymap.set("n", "<leader>fn", ":Noice telescope<CR>", { desc = "Noice telescope" })
  -- vim.keymap.set("n", "<leader>fh", function()
  --   toggle_telescope(harpoon:list())
  -- end, { desc = "Open harpoon window" })
  -- vim.keymap.set("n", "<leader>fs", ":Telescope tmuxdir sessions<CR>", { desc = "Tmuxdir sessions" })
  -- vim.keymap.set("n", "<leader>fd", ":Telescope tmuxdir dirs<CR>", { desc = "Tmuxdir dirs" })
  -- vim.keymap.set("n", "<C-s>", require("auto-session.session-lens").search_session, {
  --   noremap = true,
  -- })

  keys = {
    -- { "<leader>fe", function() Snacks.explorer() end, desc = "Explorer" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Open lazygit" },

    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>ft", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>fm", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>fr", function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fl", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- { "<leader>fh", function() Snacks.picker() end, desc = "Harpoon" },

    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },

    { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
  },
}

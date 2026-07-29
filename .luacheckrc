-- Lint rules for this Neovim config.
-- Run over tracked files: luacheck $(git ls-files '*.lua')

std = "luajit"

-- Neovim's API table. Declared writable rather than read-only because the
-- config assigns through it (vim.g.mapleader, vim.opt.tabstop, ...), which
-- read_globals would flag as mutating a read-only field.
globals = {
  "vim",
  -- Injected by folke/snacks.nvim once loaded.
  "Snacks",
}

-- Methods that ignore `self` are idiomatic here (see lua/util/fidget-spinner.lua).
self = false

-- stylua owns line length; see stylua.toml.
max_line_length = false

exclude_files = {
  "local",
}

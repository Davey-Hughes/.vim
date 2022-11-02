vim.cmd [[packadd nvim-numbertoggle]]
require'numbertoggle'.setup ({})

vim.cmd [[packadd goto-preview]]
require('goto-preview').setup({
  width = 120;
  height = 15;
  border = {'↖', '─' ,'┐', '│', '┘', '─', '└', '│'};
  default_mappings = true;
  debug = false;
  opacity = nil;

  -- Binds arrow keys to resizing the floating window.
  resizing_mappings = false;

  -- A function taking two arguments, a buffer and a window to be ran as a hook.
  post_open_hook = nil;

  -- Configure the telescope UI for slowing the references cycling window.
  references = {};

  -- Focus the floating window when opening it.
  focus_on_open = true;

  -- Dismiss the floating window when moving the cursor.
  dismiss_on_move = false;

  -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  force_close = true,

  -- the bufhidden option to set on the floating window. See :h bufhidden
  bufhidden = 'wipe',
})

vim.cmd [[packadd sniprun]]
require'sniprun'.setup({
  display = {
    'NvimNotify',
  },

  display_options = {
    terminal_width = 45,       --# change the terminal display option width
    notification_timeout = 5   --# timeout for nvim_notify output
  },
})

vim.opt.termguicolors = true;
vim.cmd [[packadd nvim-notify]]
require('notify').setup ({})

vim.cmd [[packadd nvim-web-devicons]]
require('nvim-web-devicons').setup({})

vim.cmd [[packadd lualine.nvim]]
require('lualine').setup({
  options = {
    theme = 'solarized_dark'
  },

  sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}

})

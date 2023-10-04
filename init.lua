------------------------- Davey Hughes' NeoVim config -------------------------

---------------------------------- Lazy.nvim ----------------------------------
-- set mapleader to spacebar (needs to be done before Lazy.vim is bootstrapped)
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

------------------------------- System detection ------------------------------
if vim.fn.has("mac") then
  vim.g.Darwin = 1
else
  vim.g.Darwin = 0
end

if vim.fn.has("unix") then
  vim.g.Unix = 1
else
  vim.g.Unix = 0
end

-- vim folder location
vim.cmd([[let $VIMDIR='~/.vim']])

------------------------------- General settings ------------------------------

vim.cmd([[filetype plugin indent on]])

-- wide cursor in insert mode
vim.opt.guicursor = "i:block"

-- tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- character encoding
vim.opt.encoding = "utf-8"

-- number column
vim.opt.number = true
vim.opt.relativenumber = true

-- highlight cursor line
vim.opt.cursorline = true

-- use zsh
vim.opt.shell = "fish"

-- put new splits on the right and bottom
vim.opt.splitbelow = true
vim.opt.splitright = true

-- set scrolling to start at 7 lines from the top and bottom of buffer
vim.opt.scrolloff = 7

-- set amount of entries to save in history
vim.opt.history = 10000

-- when using list, show all whitespace characters
vim.opt.listchars = "eol:$,tab:>-,trail:~,lead:·,nbsp:⎵,extends:>,precedes:<"

-- ignore case when searching except when an uppercase letter is in the search
-- pattern
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- makes search act like search in modern browsers
vim.opt.incsearch = true

-- for regular expressions turn magic on
vim.opt.magic = true

-- disable auditory bell
vim.cmd([[set visualbell t_vb=]])

-- read files if changed on disk automatically
-- for vim in the terminal, requires the plugin vim-tmux-focus-events and for
-- tmux to have > set -g focus-events on
vim.opt.autoread = true

-- search for tags recursively until $HOME directory
vim.opt.tags = "tags;$HOME"

-- use ripgrep instead of grep
vim.opt.grepprg = "rg --vimgrep --smart-case --follow"

-- always keep signcolumn open
vim.opt.signcolumn = "yes"

-- turn on hlsearch by default
vim.opt.hlsearch = true

-- turn off swapfile and backup files
vim.opt.swapfile = false
vim.opt.backup = false

-- when editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid or when inside an event handler
-- (happens when dropping a file on gvim).
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.g.cursorpos,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) <= vim.fn.line("$")
    local not_commit = vim.b[args.buf].filetype ~= "commit"

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

require("davey.remap")

vim.cmd([[source $VIMDIR/vimrc]])

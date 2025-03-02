vim.cmd([[
  :command! W w
  :command! Q q
  :command! Wq wq
  :command! WQ wq
  :command! Wqa wqa
  :command! WQa wqa
  :command! WQA wqa
]])

-- <leader><CR> enters a newline without enter insert mode
vim.keymap.set("n", "<leader><CR>", "o<Esc>")

-- <leader><Tab> inserts a real tab even when expandtab is on
vim.keymap.set("n", "<leader><Tab>", "i<C-V><Tab><Esc>")

-- let j and k move up and down lines that have been wrapped
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- move visual selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in the same place when using J
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor in middle when doing half-page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor in middle when doing searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste over a visual selection without reading selection into paste register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- <leader>y to yank into system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- <leader>d to delete into system clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["+d]])

-- <leader>s starts replacing word cursor is on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- <leader>x makes current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- remove mappings for arrow keys
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<left>", "<nop>")
vim.keymap.set("n", "<right>", "<nop>")

vim.keymap.set({ "n", "v" }, "<leader>+", "<C-a>")
vim.keymap.set({ "n", "v" }, "<leader>-", "<C-x>")

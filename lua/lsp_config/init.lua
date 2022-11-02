vim.cmd [[packadd nvim-lspconfig]]

require('lspconfig').rust_analyzer.setup({
  on_attach = on_attach,
  settings = {
    ['rust-analyzer'] = {
      assist = {
        importMergeBehavior = 'last',
        importPrefix = 'by_self',
      },
      diagnostics = {
        disabled = { 'unresolved-import' }
      },
      cargo = {
          loadOutDirsFromCheck = true
      },
      procMacro = {
          enable = true
      },
      checkOnSave = {
          command = 'clippy'
      },
    }
  }
})

require('lspconfig').pyright.setup({})
require('lspconfig').ccls.setup({})

-- load ale for all languages not configured for lspconfig
vim.cmd ([[
  let blacklist=['rust', 'python', 'c', 'cpp']
  autocmd Filetype * if index(blacklist, &ft) < 0 | packadd ale | endif
]])

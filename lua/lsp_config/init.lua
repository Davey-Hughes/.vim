vim.cmd [[packadd nvim-lspconfig]]

require'lspconfig'.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importMergeBehavior = "last",
        importPrefix = "by_self",
      },
      diagnostics = {
        disabled = { "unresolved-import" }
      },
      cargo = {
          loadOutDirsFromCheck = true
      },
      procMacro = {
          enable = true
      },
      checkOnSave = {
          command = "clippy"
      },
    }
  }
}

-- load ale for all languages not configured for lspconfig
vim.cmd ([[
  let blacklist=['rust']
  autocmd Filetype * if index(blacklist, &ft) < 0 | packadd ale | endif
]])

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

augroup stylua
    "autocmd BufWritePre *.lua lua require("stylua").format({ config_path = config_path })
augroup END

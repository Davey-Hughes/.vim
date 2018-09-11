if exists('did_load_filetypes')
    finish
endif

augroup filetypedetect
    " change filetype for .h files to 'c'
    autocmd BufNewFile,BufRead *.h,*.c setfiletype c
    autocmd BufNewFile,BufRead *.vshader,*.fshader setfiletype glsl
augroup END

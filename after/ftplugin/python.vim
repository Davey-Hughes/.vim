" indenting
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab

" run on <CR>
nnoremap <leader><CR> :!python3 %<CR>


" autopep8 settings
let g:autopep8_disable_show_diff=1
let g:autopep8_on_save=1

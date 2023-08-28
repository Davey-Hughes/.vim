" shared JavaScript family vim settings
runtime! ftplugin/jsfamily.vim

" run on <CR>
nnoremap <buffer> <leader><CR> :!node %<CR>

let b:ale_linters={
\ 'javascript': ['flow'],
\ 'javascriptreact': ['flow']
\}

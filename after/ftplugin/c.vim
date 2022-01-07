" shared C/C++ vim settings
runtime! ftplugin/cfamily.vim

" compile and run on <CR>
function! FromCSource()
    nnoremap <buffer> <leader><CR> :!gcc -std=c11 -O3 -o %:r % && ./%:r<CR>
endfunction

function! FromCMakefile()
    nnoremap <buffer> <leader><CR> :make<CR> :!./%<<CR>
endfunction

" check if there's a makefile and set the right option
if filereadable(expand(expand('<amatch>:p:h').'/*makefile'))
    call FromCMakefile()
else
    call FromCSource()
endif


" ale c compile options
let g:ale_c_cc_options='-std=c17 -Wall -Werror -Wpedantic'

" linters for C
let b:ale_linters={'c': ['ccls', 'clangtidy', 'clang']}

" disable coc for c files
let b:coc_diagnostic_disable=1

" ccls cache directory
let g:ale_c_ccls_init_options={
    \ 'cacheDirectory': '/tmp/ccls',
    \ 'cacheFormat': 'binary'
\ }

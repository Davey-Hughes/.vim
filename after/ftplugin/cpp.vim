" shared C/C++ vim settings
runtime! ftplugin/cfamily.vim

" compile and run on <CR>
function! FromCPPSource()
    nnoremap <buffer> <leader><CR> :!g++ -std=c++20 -O3 -o %:r % && ./%:r<CR>
endfunction

function! FromCPPMakefile()
    nnoremap <buffer> <leader><CR> :make<CR> :!./%<<CR>
endfunction

" check if there's a makefile and set the right option
if filereadable(expand(expand('<amatch>:p:h').'/*makefile'))
    call FromCPPMakefile()
else
    call FromCPPSource()
endif


" linters for cpp
let b:ale_linters={'cpp': ['ccls', 'clangtidy', 'clang']}

" ale cpp compile options
let g:ale_cpp_cc_options='-std=c++20 -Wall -Werror -Wpedantic'

" disable coc for cpp files
let b:coc_diagnostic_disable=1

" ccls cache directory
let g:ale_cpp_ccls_init_options={
    \ 'cacheDirectory': '/tmp/ccls',
    \ 'cacheFormat': 'binary'
\ }

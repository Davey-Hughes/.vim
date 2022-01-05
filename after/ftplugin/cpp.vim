" indenting
setlocal noexpandtab
setlocal copyindent
setlocal softtabstop=0
setlocal shiftwidth=8
setlocal tabstop=8

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


" only use ccls for CPP linting
let b:ale_linters={'cpp': ['clang']}

" cpp compile options
let g:ale_cpp_cc_options='-std=c++20 -Wall'

" disable coc for cpp files
let b:coc_diagnostic_disable=1

" ccls cache directory
let g:ale_cpp_ccls_init_options = {
\   'cache': {
\       'directory': '/tmp/ccls'
\
\   }
\ }

" clang format
let g:clang_format#auto_format=1

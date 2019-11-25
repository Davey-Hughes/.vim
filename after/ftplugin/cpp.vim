" indenting
setlocal noexpandtab
setlocal copyindent
setlocal softtabstop=0
setlocal shiftwidth=8
setlocal tabstop=8

" compile and run on <CR>
function! FromCPPSource()
    nnoremap <buffer> <leader><CR> :!g++ -std=c++17 -O3 -o %:r % && ./%:r<CR>
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

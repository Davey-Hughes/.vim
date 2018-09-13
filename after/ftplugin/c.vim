" indenting
setlocal noexpandtab
setlocal copyindent
setlocal softtabstop=0
setlocal shiftwidth=8
setlocal tabstop=8

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

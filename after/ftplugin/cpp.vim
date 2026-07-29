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

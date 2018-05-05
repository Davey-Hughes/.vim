if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
    " change filetype for .h files to 'c'
    autocmd BufNewFile,BufRead *.h,*.c setfiletype c
augroup END

augroup ftcommands
    autocmd!
    autocmd FileType text call SetTextOptions()
    function SetTextOptions()
        set textwidth=79
        set smartindent
        set noautoread
    endfunction

    autocmd FileType tex call SetTexOptions()
    function SetTexOptions()
        set textwidth=79
        set smartindent
    endfunction

    autocmd FileType c,cpp,opencl,asm,go call SetCFamilyOptions()
    function SetCFamilyOptions()
        set noexpandtab
        set copyindent
        set preserveindent
        set softtabstop=0
        set shiftwidth=8
        set tabstop=8
    endfunction

    autocmd Filetype c call SetCOptions()
    function SetCOptions()
        " compile and run on <CR>
        " MacOS
        " if g:Darwin
            " nnoremap <CR> :!gcc-7 -O3 -o %:r % && ./%:r<CR>
        " else
            " nnoremap <CR> :!gcc -O3 -o %:r % && ./%:r<CR>
        " endif
        function! FromCSource()
            nnoremap <CR> :!gcc -O3 -o %:r % && ./%:r<CR>
        endfunction

        function! FromCMakefile()
            nnoremap <CR> :make<CR> :!./%<<CR>
        endfunction

        call FromCSource()
    endfunction

    autocmd Filetype go call SetGoOptions()
    function SetGoOptions()
        " go run on <CR>
        nnoremap <CR> :GoRun<CR>
    endfunction

    autocmd Filetype cpp call SetCPPOptions()
    function SetCPPOptions()
        " compile and run on <CR>
        " MacOS
        " if g:Darwin
            " nnoremap <CR> :!g++-7 -O3 -o %:r % && ./%:r<CR>
        " else
            " nnoremap <CR> :!g++ -O3 -o %:r % && ./%:r<CR>
        " endif
        function! FromCPPSource()
            nnoremap <CR> :!g++ -O3 -o %:r % && ./%:r<CR>
        endfunction

        function! FromCPPMakefile()
            nnoremap <CR> :make<CR> :!./%<<CR>
        endfunction

        call FromCPPSource()

    endfunction

    autocmd Filetype python call SetPythonOptions()
    function SetPythonOptions()
        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set expandtab

        " run on <CR>
        nnoremap <CR> :!python3 %<CR>
    endfunction

    autocmd FileType ocaml call SetOcamlOptions()
    function SetOcamlOptions()
        syntax on
        let b:delimitMate_quotes = "\" `"
    endfunction

    autocmd FileType sh call SetShellOptions()
    function SetShellOptions()
        set tabstop=2
        set shiftwidth=2
        set softtabstop=2
        set expandtab

        " run on <CR>
        nnoremap <CR> :!./%<CR>
    endfunction

    autocmd FileType javascript call SetNodeOptions()
    function SetNodeOptions()
        nnoremap <CR> :!node %<CR>
    endfunction

augroup END

augroup templates
    " c files
    autocmd BufNewFile *.c 0r $HOME/.vim/templates/skeleton.c

    " c header files
    autocmd BufNewFile *.h
        \ 0r $HOME/.vim/templates/skeleton.h |
        \ %substitute#\[:FILENAME:\]#\=toupper(expand('%:r'))

    " cpp files
    autocmd BufNewFile *.cpp 0r $HOME/.vim/templates/skeleton.cpp

    " python files
    autocmd BufNewFile *.py 0r $HOME/.vim/templates/skeleton.py

    " Move cursor to [:CURSOR:] in file
    autocmd BufNewFile * call MoveCursor()
augroup END

function MoveCursor()
    normal gg
    if (search('\[:CURSOR:\]', 'W'))
        let l:lineno = line('.')
        let l:colno = col('.')
        substitute/\[:CURSOR:\]//
        call cursor(l:lineno, l:colno)
    endif
endfunction

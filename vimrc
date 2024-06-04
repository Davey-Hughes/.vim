""""""""""""""""""""""""""" commands for filetypes """"""""""""""""""""""""""""

augroup templates
    autocmd!

    " c files
    autocmd BufNewFile *.c silent! 0r $VIMDIR/templates/skeleton.c


    " c header files
    autocmd BufNewFile *.h
        \ silent! 0r $HOME/.vim/templates/skeleton.h |
        \ %substitute#\[:FILENAME:\]#\=toupper(expand('%:t:r'))

    " cpp files
    autocmd BufNewFile *.cc,*cpp silent! 0r $VIMDIR/templates/skeleton.cc

    " cpp header files
    autocmd BufNewFile *.hh
        \ silent! 0r $HOME/.vim/templates/skeleton.hh |
        \ %substitute#\[:FILENAME:\]#\=toupper(expand('%:t:r'))

    " python files
    autocmd BufNewFile *.py silent! 0r $VIMDIR/templates/skeleton.py

    " go files
    autocmd BufNewFile *.go silent! 0r $VIMDIR/templates/skeleton.go

    " html files
    autocmd BufNewFile *.html silent! 0r $VIMDIR/templates/skeleton.html

    " java files
    autocmd BufNewFile *.java
        \ silent! 0r $VIMDIR/templates/skeleton.java |
        \ %substitute#\[:FILENAME:\]#\=expand('%:t:r')

    " rust files
    autocmd BufNewFile *.rs silent! 0r $VIMDIR/templates/skeleton.rs

    " Move cursor to [:CURSOR:] in file
    autocmd BufNewFile * call MoveCursor()
augroup END

augroup ftdetect
    " react files
    autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
    autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
augroup END

function! MoveCursor()
    normal! gg
    if (search('\[:CURSOR:\]', 'W'))
        let l:lineno = line('.')
        let l:colno = col('.')
        substitute/\[:CURSOR:\]//
        call cursor(l:lineno, l:colno)
    endif
endfunction

""""""""""""""""""""""""""""""" misc autocmds """""""""""""""""""""""""""""""""

" Automatically close the documentation window when a selection is made
augroup completion
    autocmd!
    autocmd CompleteDone * pclose
augroup END

" when vim is resized, make splits equal
augroup resize
    autocmd!
    autocmd VimResized * wincmd =
    autocmd TabEnter * wincmd =
augroup END

""""""""""""""""""""""""""" basic toggle function """""""""""""""""""""""""""""

" Map key to toggle opt
function MapToggle(key, opt)
    let l:cmd=':set '.a:opt.'! \| set '.a:opt."?\<CR>"
    exec 'nnoremap '.a:key.' '.l:cmd
    exec 'inoremap '.a:key." \<C-O>".l:cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

" Display-altering option toggles
MapToggle <F1> hlsearch
MapToggle <F2> wrap
MapToggle <F3> list

" Behavior-altering option toggles
MapToggle <F11>  spell
MapToggle <F12> paste
set pastetoggle=<F12>

"""""""""""""""""""""""""""""""""""" undo """""""""""""""""""""""""""""""""""""

" set undo location to permanent directory in .vim folder
" executes are necessary to expand variables like $VIMDIR

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
let $VIMLOCAL=$VIMDIR . '/local'

" viminfo stores the the state of your previous editing session
execute 'set viminfofile=' . $VIMLOCAL . '/viminfo'

if exists('+undofile')
    " undofile - This allows you to use undos after exiting and restarting
    " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
    " :help undo-persistence
    " This is only present in 7.3+
    if isdirectory($VIMLOCAL . '/undo') == 0
        execute 'silent !mkdir -p ' . $VIMLOCAL . '/undo > /dev/null 2>&1'
    endif
    set undodir=./.vim-undo//
    execute 'set undodir+=' . $VIMLOCAL . '/undo//'
    set undofile
endif

"""""""""""""""""""""""""" 80 character line guides """""""""""""""""""""""""""

" highlight characters over 80 line limit
nnoremap <Leader>H :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>81v/
function! s:LongLineHLToggle()
    if !exists('w:longlinehl')
        let w:longlinehl = matchadd('ErrorMsg', '.\%>80v', 0)
        echo 'Long lines highlighted'
    else
        call matchdelete(w:longlinehl)
        unl w:longlinehl
        echo 'Long lines unhighlighted'
    endif
endfunction

highlight ColorColumn ctermbg=lightgrey guibg=lightgrey

" toggle 80 character wrap guide
nnoremap <Leader>h :call<SID>ToggleWrapGuide()<cr>
fun! s:ToggleWrapGuide()
    if &colorcolumn
        set colorcolumn=
    else
        set colorcolumn=80
    endif
endfunction

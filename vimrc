""""""""""""""""""""""""""" commands for filetypes """"""""""""""""""""""""""""

augroup templates
    autocmd!

    " c files
    autocmd BufNewFile *.c 0r $VIMDIR/templates/skeleton.c


    " c header files
    autocmd BufNewFile *.h
        \ 0r $HOME/.vim/templates/skeleton.h |
        \ %substitute#\[:FILENAME:\]#\=toupper(expand('%:t:r'))

    " cpp files
    autocmd BufNewFile *.cc,*cpp 0r $VIMDIR/templates/skeleton.cc

    " cpp header files
    autocmd BufNewFile *.hh
        \ 0r $HOME/.vim/templates/skeleton.hh |
        \ %substitute#\[:FILENAME:\]#\=toupper(expand('%:t:r'))

    " python files
    autocmd BufNewFile *.py 0r $VIMDIR/templates/skeleton.py

    " go files
    autocmd BufNewFile *.go 0r $VIMDIR/templates/skeleton.go

    " html files
    autocmd BufNewFile *.html 0r $VIMDIR/templates/skeleton.html

    " java files
    autocmd BufNewFile *.java
        \ 0r $VIMDIR/templates/skeleton.java |
        \ %substitute#\[:FILENAME:\]#\=expand('%:t:r')

    " rust files
    autocmd BufNewFile *.rs 0r $VIMDIR/templates/skeleton.rs

    " Move cursor to [:CURSOR:] in file
    autocmd BufNewFile * call MoveCursor()
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

""""""""""""""""""""""""""""""" basic keybinds """"""""""""""""""""""""""""""""

" <leader><CR> enters a newline without enter insert mode
nnoremap <leader><CR> o<Esc>

" <leader><Tab> inserts a real tab even when expandtab is on
nnoremap <leader><Tab> i<C-V><Tab><Esc>

" let j and k move up and down lines that have been wrapped
map j gj
map k gk

"""""""""""""""""""""""""""""" backup/swap/undo """""""""""""""""""""""""""""""

" set backup/swap/undo/ location to permanent directory in .vim folder
" executes are necessary to expand variables like $VIMDIR

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
let $VIMLOCAL=$VIMDIR . '/local'
if isdirectory($VIMLOCAL . '/backup') == 0
  execute 'silent !mkdir -p ' . $VIMLOCAL . '/backup >/dev/null 2>&1'
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
execute 'set backupdir^=' . $VIMLOCAL . '/backup//'
set backup

" save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($VIMLOCAL . '/swap') == 0
    execute 'silent !mkdir -p ' . $VIMLOCAL . '/swap >/dev/null 2>&1'
endif
set directory=./.vim-swap//
execute 'set directory+=' . $VIMLOCAL . '/swap//'
set directory+=~/tmp//
set directory+=.

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

""""""""""""""""""""""""""""""" misc functions """"""""""""""""""""""""""""""""

" save the previous search and restore after executing the command
function! SafeSearchCommand(theCommand)
    let l:search=@/
    execute a:theCommand
    let @/=l:search
endfunction

" trim blank lines at end of file on write
function! TrimEndLines()
    let l:save_cursor=getpos('.')
    :silent! call SafeSearchCommand('%substitute#\($\n\s*\)\+\%$##')
    call setpos('.', l:save_cursor)
endfunction

augroup onwrite
    autocmd!
    autocmd BufWritePre * call TrimEndLines()
augroup END

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

" Davey Hughes' vimrc
"
" davidralphhughes@college.harvard.edu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initial setup and notes

" YouCompleteMe
" Initially YouCompleteMe is disabled since it requires extra installation.
" You must go into bundle/YouCompleteMe/ and follow the directions in
" README.md. On Ubuntu, this requires installing build-essential, cmake,
" python-dev, and running ./install.py --clang-completer (for c-family
" completion). Then, uncomment the line that disables YouCompleteMe in the
" list of plugins section.
"
" In cases where YouCompleteMe causes a long vim startup time, use
" VimCompletesMe instead.

" In order to get the tagbar working, install ctags.

" vim-slime allows for easy sending of code from vim to a REPL. The way it is
" configured here, tmux is used as the receiving terminal, and must be opened
" for vim-slime to send code.

" The Solarized setup is dependant on your terminal settings when running vim
" from the terminal. My settings on the default Terminal for Ubuntu are
" xterm-256 colors. The color settings can be checked by running:
" > tput colors
" > echo $TERM

" The 80 character color-column specifed at the bottom of the file draws the
" line on the 80th column, so the last non-whitespace character falls on the
" 79th column. This is so the newline character happens on the 80th column.

" fzf is required to use fzf.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MacOS detection
if substitute(system('uname'), '\n', '', '') ==? 'Darwin'
    let g:Darwin=1
else
    let g:Darwin=0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Loads pathogen like a regular plugin
runtime bundle/vim-pathogen/autoload/pathogen.vim

" List of plugins (pathogen)

" VimCompletesMe
" YouCompleteMe
" ale
" codi.vim
" delimitMate
" emmet-vim
" fzf.vim
" gruvbox
" kotlin-vim
" nerdcommenter
" nerdtree
" tabline.vim
" tagbar
" undotree
" vim-airline
" vim-airline-themes
" vim-apl
" vim-better-whitespace
" vim-bufferline
" vim-coffee-script
" vim-colors-solarized
" vim-cute-python
" vim-dispatch
" vim-endwise
" vim-fugitive
" vim-gitgutter
" vim-go
" vim-nerdtree-tabs
" vim-opencl
" vim-pathogen
" vim-slime
" vim-speeddating
" vim-surround
" vim-unimpaired
" vimtex

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled=[]

" Only use one completion plugin at a time

if g:Darwin
    call add(g:pathogen_disabled, 'YouCompleteMe')
else
    call add(g:pathogen_disabled, 'VimCompletesMe')
endif

call add(g:pathogen_disabled, 'gruvbox')

execute pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands for filetypes

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

    " go files
    autocmd BufNewFile *.go 0r $HOME/.vim/templates/skeleton.go

    " html files
    autocmd BufNewFile *.html 0r $HOME/.vim/templates/skeleton.html

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" various initial settings

syntax on
filetype plugin indent on

" tab settings
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab

" character encoding
set encoding=utf-8
set fileencoding=utf-8

" turn on relative line numbers
set number
set relativenumber

" highlight the line the cursor is on
set cursorline

" set clipboard register to the same as the computer's register
set clipboard=unnamed

" use zsh
set shell=zsh

" put new splits on the right and bottom
set splitbelow
set splitright

" set scrolling to start at 7 lines from the top and bottom of buffer
set scrolloff=7

" set amount of entries to save in history
set history=10000

" when using list, show all whitespace characters
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" ignore case when searching except when an uppercase letter is in the search
" pattern
set ignorecase
set smartcase

" makes search act like search in modern browsers
set incsearch

" don't redraw while executing macros (good performance config)
set lazyredraw

" for regular expressions turn magic on
set magic

" disable auditory bell
set visualbell t_vb=

" :W sudo saves file
" command W silent w !sudo tee % > /dev/null

" when editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
augroup cursorpos
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \     exe "normal! g`\"" |
        \ endif
augroup END

" Automatically close the documentation window when a selection is made
augroup completion
    autocmd CompleteDone * pclose
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin specific settings

""" AIRLINE """
" show ALE errors in airline
let g:airline#extensions#ale#enabled = 1

" always show airline statusbar
set laststatus=2

" use powerline font for airline
let g:airline_powerline_fonts=1

" powerline solarized dark
" let g:airline_solarized_bg='dark'

" switch airline status immediately when leaving insert mode
set ttimeoutlen=10

" get rid of error section at the end
let g:airline_skip_empty_sections=1

" remove three horizontal bar symbol
" let g:airline_symbols = get(g:, 'airline_symbols', {})
" let g:airline_symbols.linenr = ''

" colorscheme
syntax enable

" try this if the terminal emulator is being weird with the colors
" if has('gui_running')
    " set background=dark
" else
    " let g:solarized_termcolors=256
    " set background=light
" endif

let g:gruvbox_contrast_dark='medium'
let g:gruvbox_contrast_light='soft'

set background=dark
set t_Co=256
colorscheme solarized

" make split indicator look thinner
highlight VertSplit ctermbg=NONE
highlight VertSplit guibg=NONE


""" YOUCOMPLETEME """
" location of ycm_extra_conf
let g:ycm_global_ycm_extra_conf='~/.vim/.config/.ycm_extra_conf.py'

" autocomplete for .tex files
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers={}
endif
let g:ycm_semantic_triggers.tex=[
    \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
    \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
    \ 're!\\hyperref\[[^]]*',
    \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
    \ 're!\\(include(only)?|input){[^}]*',
    \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
    \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
    \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
\ ]

" close preview window after completion
let g:ycm_autoclose_preview_window_after_insertion=1


""" VIM SLIME """
" vim slime use tmux
let g:slime_target='tmux'


""" NERDTREE """
" don't open automatically in GUI
let g:nerdtree_tabs_open_on_gui_startup=0


""" NERD COMMENTER """
" add space
let g:NERDSpaceDelims=1

" custom comment styles
let g:NERDCustomDelimiters={
    \ 'python': {'left': '#', 'leftAlt': '#'}
\ }


""" VIMTEX """
" disable verbose warnings
let g:vimtex_latexmk_callback=0

" error notification
let g:vimtex_compiler_latexmk={'callback' : 0}


""" TAGBAR """
" dont sort tagbar items by name alphabetically
let g:tagbar_sort=0


""" BETTER WHITESPACE """
" blacklist
let g:better_whitespace_filetypes_blacklist=[
    \ 'go', 'diff', 'gitcommit', 'unite', 'qf', 'help', 'codi'
\ ]

let g:better_whitespace_enabled=0
let g:strip_whitespace_on_save=1


""" DELIMITMATE """
" expand carrage returns
let g:delimitMate_expand_cr=1

" workaround
imap <silent> <BS> <C-R>=YcmOnDeleteChar()<CR><Plug>delimitMateBS

function! YcmOnDeleteChar()
    if pumvisible()
        return "\<C-y>"
    endif
    return ''
endfunction


""" CODI """
let g:codi#interpreters={
    \ 'python': {
        \'bin': 'python3'
    \ }
\ }


""" FZF """
set runtimepath+=/usr/local/opt/fzf


""" vim-go """
" turn off vim-go template
let g:go_template_autocreate=0

" use quickfix window instead of location list
let g:go_list_type="quickfix"

" close quickfix/loclist automatically
let g:go_list_autoclose=1

" change gofmt to goimports
let g:go_fmt_command="goimports"


""" ALE """
" change error format
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s [%severity%]'

" keep error gutter open
let g:ale_sign_column_always=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key remappings

" set mapleader to the spacebar
let g:mapleader=' '

nnoremap <F4> :StripWhitespace<CR>
nnoremap <F5> :UndotreeToggle<CR>
nnoremap <F6> :NERDTreeToggle<CR>
nnoremap <F8> :TagbarToggle<CR>
nnoremap <leader>, :TagbarOpenAutoClose<CR>
nnoremap <leader>. :TagbarOpenAutoClose<CR>/
nnoremap <leader>f :YcmCompleter FixIt<CR>

" allow changing of splits without typing ctrl-w first
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" shift-Enter enters a newline without enter insert mode
nnoremap <leader><CR> o<Esc>

" <leader><Tab> inserts a real tab even when expandtab is on
nnoremap <leader><Tab> i<C-V><Tab><Esc>

" let j and k move up and down lines that have been wrapped
map j gj
map k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic toggle function

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
MapToggle <F9>  spell
MapToggle <F10> scrollbind
MapToggle <F11> ignorecase
MapToggle <F12> paste
set pastetoggle=<F12>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set backup/swap/undo/ location to permanent directory in .vim folder

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
    :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists('+undofile')
    " undofile - This allows you to use undos after exiting and restarting
    " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
    " :help undo-persistence
    " This is only present in 7.3+
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
    endif
    set undodir=./.vim-undo//
    set undodir+=~/.vim/undo//
    set undofile
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" save the previous search and restore after executing the command
function! SafeSearchCommand(theCommand)
    let l:search=@/
    execute a:theCommand
    let @/=l:search
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" trim blank lines at end of file on write
function TrimEndLines()
    let l:save_cursor=getpos('.')
    :silent! call SafeSearchCommand('%substitute#\($\n\s*\)\+\%$##')
    call setpos('.', l:save_cursor)
endfunction

augroup onwrite
    autocmd!
    autocmd BufWritePre * call TrimEndLines()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 80 character line guides

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

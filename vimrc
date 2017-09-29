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

" In order to get the tagbar working, install ctags.

" To get the Merlin settings working for OCaml, you must install Merlin
" through opam (opam install merlin).

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Loads pathogen like a regular plugin
runtime bundle/vim-pathogen/autoload/pathogen.vim

" List of plugins (pathogen)

" ctrlp.vim
" delimitMate
" kotlin-vim
" nerdcommenter
" nerdtree
" syntastic
" tabline.vim
" tagbar
" undotree
" vim-airline
" vim-airline-themes
" vim-apl
" vim-autoread
" vim-better-whitespace
" vim-bufferline
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
" YouCompleteMe

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled=[]

" call add(g:pathogen_disabled, 'YouCompleteMe')
" call add(g:pathogen_disabled, 'nerdtree')
call add(g:pathogen_disabled, 'vim-autoread')

set nocp
execute pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" various initial settings

syntax on
filetype plugin on
filetype plugin indent on

" tab settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" use hard tabs
" set noexpandtab
" set copyindent
" set preserveindent
" set softtabstop=0
" set shiftwidth=8
" set tabstop=8

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

set shell=zsh

" put new splits on the right and bottom
set splitbelow
set splitright

" set scrolling to start at 7 lines from the top and bottom of buffer
set so=7

" set amount of entries to save in history
set history=10000

" when using list, show all whitespace characters
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" ignore case when searching
set ignorecase

" when searching try to be smart about cases
set smartcase

" makes search act like search in modern browsers
set incsearch

" don't redraw while executing macros (good performance config)
set lazyredraw

" for regular expressions turn magic on
set magic

" don't highlight matching parentheses
let g:loaded_matchparen=1

" disable auditory bell
set visualbell t_vb=

" :W sudo saves file
" command W silent w !sudo tee % > /dev/null

" when editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype specific settings

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
    nnoremap <CR> :!gcc -O3 -o %:r % && ./%:r<CR>
endfunction

autocmd Filetype go call SetGoOptions()
function SetGoOptions()
    " go run on <CR>
    nnoremap <CR> :GoRun<CR>
endfunction

autocmd Filetype cpp call SetCPPOptions()
function SetCPPOptions()
    " compile and run on <CR>
    nnoremap <CR> :!g++ -O3 -o %:r % && ./%:r<CR>
endfunction

autocmd Filetype python call SetPythonOptions()
function SetPythonOptions()
    " don't insert extra spaces
    let g:NERDSpaceDelims=0

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin specific settings

" always show airline statusbar
set laststatus=2

" use powerline font for airline
let g:airline_powerline_fonts = 1

" powerline solarized dark
" let g:airline_solarized_bg='dark'

" switch airline status immediately when leaving insert mode
set ttimeoutlen=10

" get rid of error section at the end
let g:airline_skip_empty_sections=1

" remove three horizontal bar symbol
" let g:airline_symbols = get(g:, 'airline_symbols', {})
" let g:airline_symbols.linenr = ''

" solarized
syntax enable

" try this if the terminal emulator is being weird with the colors
" if has('gui_running')
    " set background=dark
" else
    " let g:solarized_termcolors=256
    " set background=light
" endif

set background=dark
set t_Co=256
colorscheme solarized

" location of ycm_extra_conf
let g:ycm_global_ycm_extra_conf='~/.vim/.config/.ycm_extra_conf.py'

" merlin settings
let g:opamshare=substitute(system('opam config var share'),'\n$','','''')
execute 'set rtp+=' . g:opamshare . '/merlin/vim'
let maplocalleader="\\"
let g:syntastic_ocaml_checkers=['merlin']

" ocp indent
set rtp+=/home/ubuntu/cs51/ocp-indent-vim

" vim slime use tmux
let g:slime_target='tmux'

" NERDTree don't open automatically in GUI
let g:nerdtree_tabs_open_on_gui_startup = 0

" NERDCommenter add space
let g:NERDSpaceDelims=1

" NERDCommenter change comment style
let g:NERDComAltDelims=1

" vimtex disable verbose warnings
let g:vimtex_latexmk_callback=0

" YouCompleteMe autocomplete for .tex files
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
  endif
  let g:ycm_semantic_triggers.tex = [
        \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
        \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
        \ 're!\\hyperref\[[^]]*',
        \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
        \ 're!\\(include(only)?|input){[^}]*',
        \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
        \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
        \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
        \ ]

" YouCompleteMe close preview window after completion
let g:ycm_autoclose_preview_window_after_insertion=1

" ctrlp extensions
let g:ctrlp_extensions = ['tag', 'buffertag']
let g:ctrlp_switch_buffer='ETVH'
let g:ctrlp_cmd = 'CtrlPTag'

" dont sort tagbar items by name alphabetically
let g:tagbar_sort=0

" better whitelist blacklist
let g:better_whitespace_filetypes_blacklist = [
        \ 'go', 'diff', 'gitcommit', 'unite', 'qf', 'help']

" vim linter
let g:syntastic_vim_checkers = ['vint']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key remappings

" set mapleader to the spacebar
let mapleader=' '

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
nnoremap <S-CR> O<Esc>
nnoremap <leader><CR> o<Esc>

" <leader>-Tab inserts a real tab even when expandtab is on
nnoremap <leader><Tab> i<C-V><Tab><Esc>

" let j and k move up and down lines that have been wrapped
map j gj
map k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic toggle function

" Map key to toggle opt
function MapToggle(key, opt)
  let cmd=':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
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
" trim blank lines at end of file on write

function TrimEndLines()
    let save_cursor = getpos('.')
    :silent! %s#\($\n\s*\)\+\%$##
    call setpos('.', save_cursor)
endfunction

autocmd BufWritePre * call TrimEndLines()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 80 character line guides

" highlight characters over 80 line limit
nnoremap <Leader>H :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>81v/
fun! s:LongLineHLToggle()
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

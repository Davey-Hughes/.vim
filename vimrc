" Davey Hughes's vimrc
" 64bit Vim
"
" Windows 10 Pro, x64
" Windows PowerShell
"
" Arch Linux 2016.01.01 x86_64
" zsh with oh-my-zsh
"
" February 1, 2016
" davidralphhughes@college.harvard.edu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" List of plugins (pathogen)

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

call add(g:pathogen_disabled, 'vim-expand-region')
call add(g:pathogen_disabled, 'YouCompleteMe')

" ctrlp.vim
" delimitmate
" gundo
" nerdcommenter
" nerdtree
" rainbow
" syntastic
" tagbar
" vim-airline
" vim-better-whitespace
" vim-bufferline
" vim-colors-solarized
" vim-dispatch
" vim-endwise
" vim-expand-region
" vim-fugitive
" vim-gitgutter
" vim-nerdtree-tabs
" vim-speeddating
" vim-surround
" vim-unimpaired
" YouCompleteMe

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

" character encoding
set encoding=utf-8
set fileencoding=utf-8

" turn on line numbers
set number

" reload file if it's been changed externally
" set autoread

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

" highlight search results
set hlsearch

" makes search act like search in modern browsers
set incsearch

" don't redraw while executing macros (good performance config)
set lazyredraw

" for regular expressions turn magic on
set magic

" don't highlight matching parentheses
let g:loaded_matchparen=1

" :W sudo saves file
command W silent w !sudo tee % > /dev/null

" when editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype specific settings

autocmd FileType text set textwidth=79 smartindent noautoread
autocmd FileType ocaml syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin specific settings

" always show airline statusbar
set laststatus=2

" turn on rainbow colored braces
let g:rainbow_active = 1

" solarized
syntax enable
set background=dark
colorscheme solarized

" location of ycm_extra_conf
let g:ycm_global_ycm_extra_conf = '~/.vim/.config/'

" merlin settings
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
let maplocalleader = "\\"
let g:syntastic_ocaml_checkers=['merlin']

" ocp indent
set rtp+=/home/ubuntu/cs51/ocp-indent-vim

" vim slime use tmux
let g:slime_target = "tmux"

" NERDCommenter add space
let NERDSpaceDelims = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key remappings

" set mapleader to the spacebar
let mapleader = " "

nnoremap <leader>d dd

nnoremap <F4> :StripWhitespace<CR>
nnoremap <F5> :GundoToggle<CR>
nnoremap <F6> :NERDTreeToggle<CR>
nnoremap <F8> :TagbarToggle<CR>

" allow changing of splits without typing ctrl-w first
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" shift-Enter enters a newline without enter insert mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" shift-Tab inserts a real tab even when expandtab is on
:nnoremap <leader><Tab> i<C-V><Tab><Esc>

" let j and k move up and down lines that have been wrapped
map j gj
map k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic toggle function

" Map key to toggle opt
function MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
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
" set backup/swap/undo location to permanent directory in .vim folder

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

if exists("+undofile")
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
    let save_cursor = getpos(".")
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
    echo "Long lines highlighted"
  else
    call matchdelete(w:longlinehl)
    unl w:longlinehl
    echo "Long lines unhighlighted"
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

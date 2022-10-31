" Davey Hughes' vimrc
"
" davidralphhughes@gmail.com

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MacOS detection
if substitute(system('uname'), '\n', '', '') ==? 'Darwin'
    let g:Darwin=1
else
    let g:Darwin=0
endif

" vim folder location
let $VIMDIR='~/.vim'
let $VIMSUBDIR=$VIMDIR . '/vim'

if has('nvim')
    let $VIMDIR='~/.config/nvim'
    let $VIMSUBDIR=$VIMDIR . '/nvim'

    set guicursor=i:block

    " initialize lsp_config for nvim
    lua require('lsp_config')
else
    " load ale in vim
    packadd ale
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" plugins

" colorschemes
"     start
"         NeoSolarized
" LSP
"     start
"         coc.nvim
"         vim-pythonx
"     opt
"         ale
"         nvim-lspconfig
" filetypes
"     start
"         kotlin-vim
"         rust.vim
"         typescript.vim
"         vim-coffee-script
"         vim-cpp-modern
"         vim-cute-python
"         vim-go
"         vim-opencl
"         vimtex
" formatters
"     start
"         vim-autopep8
"         vim-clang-format
"         vim-prettier
" fzf
"     start
"         fzf-preview.vim
"         fzf.vim
" git
"     start
"         vim-flog
"         vim-fugitive
" misc
"     start
"         vim-dispatch
"         vim-obsession
"         vim-prosession
"         vim-sleuth
"         vim-slime
"         webapi-vim
" text_editing
"     start
"         delimitMate
"         emmet-vim
"         nerdcommenter
"         vim-better-whitespace
"         vim-endwise
"         vim-speeddating
"         vim-surround
"         vim-unimpaired
" tmux
"     start
"         vim-tmux-focus-events
"         vim-tmux-navigator
" ui
"     start
"         indentLine
"         nerdtree
"         tabline.vim
"         undotree
"         vim-airline
"         vim-airline-themes
"         vim-bookmarks
"         vim-devicons
"         vim-nerdtree-tabs
"         vim-tabdrop
"         vista.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands for filetypes

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
    autocmd BufNewFile *.rs 0r $VIMDIR/.vim/templates/skeleton.rs

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

set backspace=indent,eol,start

syntax on
filetype plugin indent on

" tab settings
set tabstop=4
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
set listchars=eol:$,tab:>-,trail:~,lead:·,nbsp:⎵,extends:>,precedes:<

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

" read files if changed on disk automatically
" for vim in the terminal, requires the plugin vim-tmux-focus-events and for
" tmux to have > set -g focus-events on
set autoread

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
    autocmd!
    autocmd CompleteDone * pclose
augroup END

" search for tags recursively until $HOME directory
set tags=tags;$HOME

" use ripgrep instead of grep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" set mapleader to the spacebar
let g:mapleader=' '

" select auto regex engine (instead of old by default)
set regexpengine=0

" always keep signcolumn open
set signcolumn=yes

" turn on hlsearch by default
set hlsearch

" when vim is resized, make splits equal
augroup resize
    autocmd!
    autocmd VimResized * wincmd =
    autocmd TabEnter * wincmd =
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

" Vim obsession airline extension
let g:airline#extensions#obsession#enabled=1
let g:airline#extensions#obsession#indicator_text='$'


""" Colorscheme Stuff """
syntax enable

set background=dark
set termguicolors
let g:neosolarized_patched=1
colorscheme NeoSolarized

" make split indicator look thinner
highlight VertSplit ctermbg=NONE
highlight VertSplit guibg=NONE


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
    \ 'python': {'left': '#', 'leftAlt': '#'},
    \ 'c': {'left': '/*', 'leftAlt': '//', 'right': '*/', 'rightAlt': ''}
\ }


""" VIMTEX """
" disable verbose warnings
let g:vimtex_latexmk_callback=0

" error notification
let g:vimtex_compiler_latexmk={'callback' : 0}


""" VISTA """
let g:vista_icon_indent=["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon=1
let g:vista_stay_on_open=0

" close vista if the last buffer is closed
augroup vista
    autocmd!
    autocmd bufenter *
        \ if winnr("$") == 1 && vista#sidebar#IsOpen() |
            \ execute "normal! :q!\<CR>" |
        \ endif
augroup END


""" BETTER WHITESPACE """
" blacklist
let g:better_whitespace_filetypes_blacklist=[
    \ 'go', 'diff', 'gitcommit', 'unite', 'qf', 'help'
\ ]

let g:better_whitespace_enabled=0
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

augroup better-whitespace
    autocmd!
    autocmd FileType markdown let b:strip_whitespace_on_save=0
augroup END


""" FZF """
set runtimepath+=/usr/local/opt/fzf
" use PRg to use Rg in git project
command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': system('git rev-parse --show-toplevel 2> /dev/null')[:-2]}), <bang>0)

nnoremap <C-P> :PRg<CR>


let g:fzf_action={
  \ 'ctrl-t': 'Tabdrop',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
\ }


""" FZF-PREVIEW """
nmap <leader>f [fzf-p]
xmap <leader>f [fzf-p]

nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>


""" ALE """
" change error format
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s [%severity%]'


""" COC """
" if hidden is not set, TextEdit might fail.
set hidden

" make inlay hint background the correct color
if has('nvim')
  highlight CocInlayHint ctermfg=7 ctermbg=0 guifg=LightGrey guibg=1
endif

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>ql  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


""" DELIMITMATE """
let b:delimitMate_expand_cr=1


""" TABDROP """
nnoremap <C-]> :TagTabdrop<CR>
vnoremap <C-]> <Esc>:TagTabdrop<CR>


""" INDENT LINE """
" use colorscheme instead of grey
let g:indentLine_setColors=0


""" Prosession """
let g:prosession_dir=$VIMSUBDIR . '/sessions/'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" make SignColumn the same color as the line number column
highlight! link SignColumn LineNr

nnoremap <F4> :StripWhitespace<CR>
nnoremap <F5> :UndotreeToggle<CR>
nnoremap <F6> :NERDTreeToggle<CR>
nnoremap <F8> :Vista!!<CR>

" allow changing of splits without typing ctrl-w first
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" <leader><CR> enters a newline without enter insert mode
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
" executes are necessary to expand variables like $VIMDIR

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($VIMSUBDIR . '/backup') == 0
  execute 'silent !mkdir -p ' . $VIMSUBDIR . '/backup >/dev/null 2>&1'
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
execute 'set backupdir^=' . $VIMSUBDIR . '/backup//'
set backup

" save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($VIMSUBDIR . '/swap') == 0
    execute 'silent !mkdir -p ' . $VIMSUBDIR . '/swap >/dev/null 2>&1'
endif
set directory=./.vim-swap//
execute 'set directory+=' . $VIMSUBDIR . '/swap//'
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
execute 'set viminfofile=' . $VIMSUBDIR . '/viminfo'

if exists('+undofile')
    " undofile - This allows you to use undos after exiting and restarting
    " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
    " :help undo-persistence
    " This is only present in 7.3+
    if isdirectory($VIMSUBDIR . '/undo') == 0
        execute 'silent !mkdir -p ' . $VIMSUBDIR . '/undo > /dev/null 2>&1'
    endif
    set undodir=./.vim-undo//
    execute 'set undodir+=' . $VIMSUBDIR . '/undo//'
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
function! TrimEndLines()
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

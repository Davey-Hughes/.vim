"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI settings

" font
set guifont=Hack:h13

augroup guicommands
    " autocmd VimLeave * call ExitMacVim()
    " function ExitMacVim()
        " if &fullscreen
            " set fu!
        " endif
        " :!open -a iTerm
    " endfunction

    " autocmd VimEnter * call EnterMacVim()
    " function EnterMacVim()
        " :sleep 100m
        " :set fu
    " endfunction
augroup END

" Remove scrollbars
set guioptions=

" disable blinking cursor
set guicursor+=a:blinkon0

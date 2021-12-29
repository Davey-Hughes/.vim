" indenting
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab

" compile and run on <leader><CR>
function! FromRustSource()
    nnoremap <buffer> <leader><CR> :!rustc % && ./%:r<CR>
endfunction

function! FromCargoProject()
    nnoremap <buffer> <leader><CR> :make run<CR>
    nnoremap <buffer> `<CR> :Dispatch cargo run<CR>
endfunction

if !empty(findfile('Cargo.toml', getcwd().';'))
    call FromCargoProject()
else
    call FromRustSource()
endif


" format on save
let g:rustfmt_autosave=1

" copying RustPlay URL to clipboard
if (g:Darwin)
    let g:rust_clip_command='pbcopy'
else
    let g:rust_clip_command='xclip -selection clipboard'
endif

let g:ale_linters={
    \ 'rust': [
        \ 'analyzer'
    \ ]
\ }

" delimitMate settings
let b:delimitMate_matchpairs="(:),[:],{:}"

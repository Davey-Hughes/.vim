" indenting
setlocal noexpandtab
setlocal copyindent
setlocal softtabstop=0
setlocal shiftwidth=8
setlocal tabstop=8

" go run on <CR>
nnoremap <buffer> <leader><CR> :GoRun -F<CR>
nmap <silent> <Leader>gd <Plug>(go-def-tab)

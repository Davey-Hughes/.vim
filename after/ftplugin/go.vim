" indenting
setlocal noexpandtab
setlocal copyindent
setlocal softtabstop=0
setlocal shiftwidth=8
setlocal tabstop=8

" go run on <CR>
nnoremap <buffer> <leader><CR> :GoRun<CR>
nmap <silent> <Leader>gd <Plug>(go-def-tab)


""" vim-go """
" turn off vim-go template
let g:go_template_autocreate=0

" use quickfix window instead of location list
let g:go_list_type='quickfix'

" close quickfix/loclist automatically
let g:go_list_autoclose=1

" change gofmt to goimports
let g:go_fmt_command='goimports'

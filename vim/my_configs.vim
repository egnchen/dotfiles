" basics
set mouse=a
set nu
set relativenumber

" use space as leader
nnoremap <space> <nop>
nnoremap <C-space> <nop>
map <space> <leader>

" I want my ctrl+f, ctrl+b back
let g:ctrlp_map='<c-p>'

" set 4-space tabbing
set tabstop=4
set shiftwidth=4
set expandtab

" colorscheme
colorscheme dracula

" configure ack to use ripgrep
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'


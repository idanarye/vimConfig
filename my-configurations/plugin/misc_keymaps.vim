nnoremap <A-j> :m+<CR>==
nnoremap <A-k> :m-2<CR>==
inoremap <A-j> <Esc>:m+<CR>==gi
inoremap <A-k> <Esc>:m-2<CR>==gi
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-k> :m-2<CR>gv=gv

nnoremap <A-x> <C-a>
inoremap <A-e> <C-y>

nnoremap <A-e> <C-y>

nnoremap <A-2> @@

nmap <A-n> <Plug>MarkSearchAnyNext

nnoremap <A-h> <Esc>:SidewaysLeft<Cr>
nnoremap <A-l> <Esc>:SidewaysRight<Cr>

noremap <Leader><Tab> <Esc>:NERDTreeToggle<Cr>
noremap <Leader><C-c> <Esc>:noh<Bar>MarkClear<Cr>

nnoremap <Leader><C-r> <Esc>:call myrainbow#toggle()<Cr>
nnoremap <Leader><C-s> <Esc>:execute "setfiletype" &filetype<Cr>

nnoremap Y y$

noremap <Leader>gc <Esc>:Gcommit<Cr>
noremap <Leader>gs <Esc>:Gstatus<Cr>

nnoremap <Leader><C-f> :PSearch<Cr>

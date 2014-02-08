execute 'command! ReloadKeymaps source '.expand("<sfile>")

nnoremap <A-j> :m+<CR>==
nnoremap <A-k> :m-2<CR>==
inoremap <A-j> <Esc>:m+<CR>==gi
inoremap <A-k> <Esc>:m-2<CR>==gi
"vnoremap <A-j> :m'>+<CR>gv=gv
"vnoremap <A-k> :m-2<CR>gv=gv

nnoremap <A-x> <C-a>
inoremap <A-e> <C-y>

nnoremap <A-e> <C-y>

nnoremap <A-2> @@

nmap <A-n> <Plug>MarkSearchAnyNext

"nnoremap <A-h> <Esc>:SidewaysLeft<Cr>
"nnoremap <A-l> <Esc>:SidewaysRight<Cr>

xmap <M-j> <Plug>(textmanip-move-down)
xmap <M-k> <Plug>(textmanip-move-up)
xmap <M-h> <Plug>(textmanip-move-left)
xmap <M-l> <Plug>(textmanip-move-right)

noremap <Leader><Tab> <Esc>:NERDTreeToggle<Cr>
noremap <Leader><C-c> <Esc>:noh<Bar>MarkClear<Cr>

nnoremap <Leader><C-r> <Esc>:call myrainbow#toggle()<Cr>
nnoremap <Leader><C-s> <Esc>:execute "setfiletype" &filetype<Cr>
nnoremap <Leader><A-s> <Esc>:set spell!<Cr>
nnoremap <Leader><A-w> <Esc>:set wrap!<Cr>

nnoremap Y y$

nnoremap <Leader><C-f> :PSearch<Cr>

nnoremap <Leader><C-d>t :diffthis<Cr>
nnoremap <Leader><C-d>o :diffoff<Cr>
nnoremap <Leader><C-d>u :diffupdate<Cr>
vnoremap <Leader><C-d>g :diffget<Cr>
vnoremap <Leader><C-d>p :diffput<Cr>

command! UseRailsIndentations set expandtab | set tabstop=2 | set shiftwidth=2 | retab
command! UseRegularIndentations set expandtab | set tabstop=4 | set shiftwidth=4 | retab

nnoremap <Leader><Leader>h :BreezeJumpF<Cr>
nnoremap <Leader><Leader>H :BreezeJumpB<Cr>

nnoremap <Leader><C-h>j :BreezeNextSibling<Cr>
nnoremap <Leader><C-h>k :BreezePrevSibling<Cr>
nnoremap <Leader><C-h>K :BreezeFirstSibling<Cr>
nnoremap <Leader><C-h>J :BreezeLastSibling<Cr>
nnoremap <Leader><C-h><C-k> :BreezeFirstChild<Cr>
nnoremap <Leader><C-h><C-j> :BreezeLastChild<Cr>
nnoremap <Leader><C-h>p :BreezeParent<Cr>

vnoremap <silent> <Leader>a :EasyAlign<Cr>

nnoremap dic :call Del my-configurations/plugin/misc_keymaps.vim

"keymaps for fugitive:
noremap <Leader>gs <Esc>:Gstatus<Cr>
noremap <Leader>ge <Esc>:Gedit<Cr>
noremap <Leader>gd <Esc>:Gdiff<Cr>
noremap <Leader>gl <Esc>:Gllog<Cr>
noremap <Leader>gb <Esc>:Gblame<Cr>

"Map for setting marks after easyclip took `m`:
noremap <M-m> m

"keymap for ttoc
nnoremap <Leader>t :Ttoc<Cr>

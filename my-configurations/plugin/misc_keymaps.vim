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

"nnoremap <A-h> :SidewaysLeft<Cr>
"nnoremap <A-l> :SidewaysRight<Cr>

xmap <M-j> <Plug>(textmanip-move-down)
xmap <M-k> <Plug>(textmanip-move-up)
xmap <M-h> <Plug>(textmanip-move-left)
xmap <M-l> <Plug>(textmanip-move-right)

noremap <Leader><Tab> :NERDTreeToggle<Cr>
noremap <Leader><C-c> :noh<Bar>MarkClear<Cr>

"nnoremap <Leader><C-r> :call myrainbow#toggle()<Cr>
nnoremap <Leader><C-r> :RainbowToggle<Cr>
nnoremap <Leader><C-s> :set spell!<Cr>
nnoremap <Leader><A-f> :filetype detect<Cr>
nnoremap <Leader><A-w> :set wrap!<Cr>

nnoremap Y y$

nnoremap <Leader><C-f> :PSearch<Cr>
nnoremap <Leader><A-s> :VimShellPop<Cr>

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

"keymaps for Fugitive:
noremap <Leader>gs :Gstatus<Cr>
noremap <Leader>ge :Gedit<Cr>
noremap <Leader>gd :Gvdiff<Cr>
noremap <Leader>gl :Gllog<Cr>
noremap <Leader>gL :GitLog<Cr>
noremap <Leader>gb :Gblame<Cr>
noremap <Leader>gf :Git fetch<Cr>

"This one is for my very own Merginal
noremap <Leader>gm :Merginal<Cr>

"This one if for Extradite
noremap <Leader>gE :Extradite!<Cr>

"Map for setting marks after easyclip took `m`:
noremap <M-m> m

"keymap for ttoc
nnoremap <Leader>t :Ttoc<Cr>


"keymaps for Bufstop
nnoremap <Leader>bb :Bufstop<Cr>
nnoremap <Leader>bs :BufstopStatusline<Cr>

"keymaps for vim-bookmarks
nmap <Leader><C-m>m <Plug>BookmarkToggle
nmap <Leader><C-m><C-m> <Plug>BookmarkToggle
nmap <Leader><C-m>i <Plug>BookmarkAnnotate
nmap <Leader><C-m>a <Plug>BookmarkShowAll
nmap <Leader><C-m>j <Plug>BookmarkNext
nmap <Leader><C-m>k <Plug>BookmarkPrev
nmap <Leader><C-m>c <Plug>BookmarkClear
nmap <Leader><C-m>x <Plug>BookmarkClearAll


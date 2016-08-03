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
nmap <A-h> <Plug>(swap-prev)
nmap <A-l> <Plug>(swap-next)

xmap <M-j> <Plug>(textmanip-move-down)
xmap <M-k> <Plug>(textmanip-move-up)
xmap <M-h> <Plug>(textmanip-move-left)
xmap <M-l> <Plug>(textmanip-move-right)

noremap <Leader><Tab> :NERDTreeToggle<Cr>
noremap <Leader><Leader><Tab> :NERDTreeFind<Cr>
noremap <Leader><C-c> :nohlsearch<Bar>MarkClear<Cr>
"Sometimes <Leader><C-c> doesn't work for whatever odd reason...
noremap <Leader><M-c> :nohlsearch<Bar>MarkClear<Cr>

"nnoremap <Leader><C-r> :call myrainbow#toggle()<Cr>
nnoremap <Leader><C-r> :RainbowToggle<Cr>
nnoremap <Leader><C-s> :setlocal spell! <Bar> syntax spell toplevel<Cr>
nnoremap <Leader><C-l> :set list!<Cr>
nnoremap <Leader><A-l> :set number!<Cr>
nnoremap <Leader><A-f> :filetype detect<Cr>
nnoremap <Leader><A-w> :set wrap!<Cr>
nnoremap <Leader><C-t> :checktime<Cr>

nnoremap Y y$

nnoremap <Leader><C-f> :PSearch<Cr>
if exists(':terminal')
	nnoremap <Leader><A-s> :new <Bar> terminal<Cr>
else
	nnoremap <Leader><A-s> :VimShellPop<Cr>
endif

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
noremap <Leader>gf :call merginal#bang('git fetch --prune')<Cr>
noremap <Leader>gu :call merginal#bang('git submodule update --init')<Cr>

"This one is for my very own Merginal
noremap <Leader>gm :MerginalToggle<Cr>

"This one if for Extradite
noremap <Leader>gE :Extradite!<Cr>

"Map for setting marks after easyclip took `m`:
noremap <C-M-m> m

"keymap for ttoc
nnoremap <Leader>t :Ttoc<Cr>


"keymaps for Bufstop
nnoremap <Leader>bb :Bufstop<Cr>
nnoremap <Leader>bs :BufstopStatusline<Cr>

"keymaps for vim-bookmarks
nmap <M-m>m <Plug>BookmarkToggle
nmap <M-m><C-m> <Plug>BookmarkToggle
nmap <M-m>i <Plug>BookmarkAnnotate
nmap <M-m>a <Plug>BookmarkShowAll
nmap <M-m>j <Plug>BookmarkNext
nmap <M-m>k <Plug>BookmarkPrev
nmap <M-m>c <Plug>BookmarkClear
nmap <M-m>x <Plug>BookmarkClearAll

"keymaps for working with tabs
nnoremap <M-t>n :tabnew<Cr>
nnoremap <M-t>q :tabclose<Cr>
nnoremap <M-t>c :tabclose<Cr>
nnoremap <M-t>o :tabonly<Cr>
nnoremap <M-t>l :tabmove +1<Cr>
nnoremap <M-t>L :tabmove<Cr>
nnoremap <M-t>h :tabmove -1<Cr>
nnoremap <M-t>H :tabmove 0<Cr>

"keymaps for quick access to Unite modes
"if has('nvim')
	"nnoremap <C-p> :Unite file_rec/neovim<Cr>
"else
	"nnoremap <C-p> :Unite file_rec/async<Cr>
"endif
"nnoremap <M-p><C-b> :Unite buffer<Cr>
"nnoremap <M-p>l :Unite line<Cr>
"nnoremap <M-p><C-m> :Unite file_mru<Cr>
"nnoremap <M-p>g :Unite grep:.<Cr>
"nnoremap <M-p>m :Unite git/modified<Cr>
"nnoremap <M-p>b :Unite git/branch<Cr>

"keymaps for quick access to CtrlP modes
nnoremap <M-p>l :CtrlPLine<Cr>
"nnoremap <M-p>f :CtrlPFunky<Cr>
nnoremap <M-p>m :CtrlPModified<Cr>
nnoremap <M-p><C-m> :CtrlPMRUFiles<Cr>
nnoremap <M-p>b :CtrlPBranch<Cr>
nnoremap <M-p>r :CtrlPRoot<Cr>
nnoremap <M-p>c :CtrlPChange<Cr>
nnoremap <M-p>u :CtrlPUndo<Cr>
nnoremap <M-p>q :CtrlPQuickfix<Cr>
nnoremap <M-p><C-b> :CtrlPBuffer<Cr>
nnoremap <M-p>t :CtrlPTag<Cr>
nnoremap <M-p><C-t> :CtrlPBufTag<Cr>
nnoremap <M-p>s :call ctrlp#init(ctrlp#sift#id())<Cr>

"I don't really need these:
":CtrlPDir
":CtrlPRTS
":CtrlPMixed
":CtrlPBookmarkDir

"Keymaps for RengBang
map <Leader>sr <Plug>(operator-rengbang)
map <Leader>sp <Plug>(operator-rengbang-useprev)
nnoremap <Leader>sR :RengBangConfirm<Cr>
vnoremap <Leader>sR :RengBangConfirm<Cr>

nnoremap <Leader>w :call argwrap#toggle()<Cr>

nnoremap <Leader><C-a> :AnsiEsc<Cr>

let g:casetrate_leader = '<M-c>'

let g:no_cecutil_maps = 1

"Keymaps for multicursor
let g:multicursor_quit = "\<Esc>"
nnoremap <Leader><C-m>p :call MultiCursorPlaceCursor()<Cr>
nnoremap <Leader><C-m>r :call MultiCursorRemoveCursors()<Cr>
nnoremap <Leader><C-m>m :call MultiCursorManual()<Cr>
nnoremap <Leader><C-m>v :call MultiCursorVisual()<Cr>
xnoremap <Leader><C-m>s :call MultiCursorSearch('')<Cr>

"Some keymaps I don't want to put in the main vebugger plugin:
execute 'nnoremap '.g:vebugger_leader.'k :VBGkill<Cr>'


if exists('&fullscreen')
	nnoremap <F11> :set fullscreen!<Cr>
elseif has('nvim')
	nnoremap <F11> :call GuiWindowFullScreen(!g:GuiWindowFullScreen)<Cr>
endif

nnoremap gll :LazyList<CR>
vnoremap gll :LazyList<CR>
nnoremap gl* :LazyList ' * '<CR>
vnoremap gl* :LazyList ' * '<CR>
nnoremap gl- :LazyList ' - '<CR>
vnoremap gl- :LazyList ' - '<CR>
nnoremap gl+ :LazyList ' + '<CR>
vnoremap gl+ :LazyList ' + '<CR>

nnoremap <Leader>d :Doing<Cr>

nnoremap <Leader>ld :Linediff<Cr>
vnoremap <Leader>ld :Linediff<Cr>
nnoremap <Leader>lD :LinediffReset<Cr>

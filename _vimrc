" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  autocmd BufEnter * lcs %:p:h
  autocmd BufEnter * cd %:p:h




  augroup END

else

  set autoindent		" always set autoindenting on
  set autochdir

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


"	MY OWN SETTINGS

cd %:p:h

set go-=m
set go-=T

let maplocalleader="\<C-\>"

set ruler
set vb t_vb=
set virtualedit=all
set tabstop=4
set shiftwidth=4
"set makeprg=mingw32-make
if has("autocmd")
" autocmd BufNewFile,BufRead *.py setlocal expandtab
  au BufRead,BufNewFile *.hta setlocal filetype=vb

  au BufRead,BufNewFile *.pri setlocal filetype=xml
  au BufRead,BufNewFile *.prr setlocal filetype=xml
  au BufRead,BufNewFile *.prt setlocal filetype=xml

  "au filetype c compiler gcc
  "au filetype cpp compiler gcc

  "au filetype java compiler java

  "au BufRead,BufNewFile *.csproj compiler dotnet
  "au filetype cs compiler dotnet

  "au filetype ruby compiler ruby

  let NERD_asm_alt_style=1
  au filetype asm set autoindent

  au BufRead,BufNewFile * compiler rake

  autocmd filetype python setlocal expandtab


  autocmd filetype c setlocal dict+=$vim\dictionaries\c.dic
  autocmd filetype cpp setlocal dict+=$vim\dictionaries\cpp.dic
  autocmd filetype cs setlocal dict+=$vim\dictionaries\cs.dic
  autocmd filetype html setlocal dict+=$vim\dictionaries\html.dic
  autocmd filetype python setlocal dict+=$vim\dictionaries\python.dic
  autocmd filetype sql setlocal dict+=$vim\dictionaries\sql.dic
  autocmd filetype vb setlocal dict+=$vim\dictionaries\vb.dic

endif

"command Cmd ConqueTerm cmd

let g:ftplugin_sql_omni_key = 'ã' "This is actuall <A-C>
command! -complete=dir -nargs=* -count=0 Ex call netrw#Explore(<count>,0,0+<bang>0,<q-args>)
" DBEXT SETTINGS
runtime dbextProfiles.vim

" Fugitive SETTINGS
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
autocmd BufReadPost fugitive://* set bufhidden=delete
noremap <Leader>gc <Esc>:Gcommit<Cr>
noremap <Leader>gs <Esc>:Gstatus<Cr>

filetype indent on

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

let g:ConqueTerm_ToggleKey = '<F8>'
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_ReadUnfocused = 1


if has('win32')
	silent execute '!mkdir "'.$VIMRUNTIME.'/temp"'
	silent execute '!del "'.$VIMRUNTIME.'/temp/*~"'
	set backupdir=$VIMRUNTIME/temp//
	set directory=$VIMRUNTIME/temp//
	map <F9> <Esc>:!%<CR>
elseif has('unix')
	silent execute '!mkdir -p ~/.vimtmp'
	silent execute '!rm -f ~/.vimtmp/*'
	set backupdir=~/.vimtmp//
	set directory=~/.vimtmp//
	map <F9> <Esc>:!./%<CR>
endif


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

function! CopyBuildFile(pattern)
	let buildFiles=split(system("ls ".a:pattern." -1"),"\n")
	let fileNames=[]
	for buildFile in buildFiles
		let buildFile=strpart(buildFile,strridx(buildFile,"/")+1)
		let fileNames=fileNames+[(len(fileNames)+1).": ".buildFile]
	endfor
	let selectedIndex=inputlist(["Select build template"]+fileNames)-1
	if selectedIndex>=0&&selectedIndex<len(buildFiles)
		let selectedFile=buildFiles[selectedIndex]
		call system("cp -f ".selectedFile." ./rakefile")
	endif
endfunc

command! GetBuildFile call CopyBuildFile("~/.vim/buildTemplates/*.rake") | compiler rake

command! CDhere exe "cd ".expand("%:p:h")

noremap <Leader><Tab> <Esc>:NERDTreeToggle<Cr>
noremap <Leader><C-c> <Esc>:noh<Bar>MarkClear<Cr>

nnoremap <Leader><C-r> <Esc>:call myrainbow#toggle()<Cr>
nnoremap <Leader><C-s> <Esc>:execute "setfiletype" &filetype<Cr>

nnoremap Y y$

let g:UltiSnipsSnippetDirectories=['snippets']

autocmd FileType clojure setlocal indentexpr=myclojure#clojureIndent()
autocmd FileType clojure setlocal indentkeys+=0),0},0]

autocmd FileType vim map <buffer> <F9> <Esc>:source %<Cr>

source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction


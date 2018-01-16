" Vim compiler file
" Compiler: MinGW

if exists("current_compiler")
finish
endif
let current_compiler = "MinGW"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
command -nargs=* CompilerSet setlocal <args>
endif

" default errorformat
CompilerSet errorformat=\ %#%f(%l\\\,%c):\ %m

" default make

CompilerSet makeprg=make

map <buffer> <F2> <Esc>:silent !ctags *.h *.cpp *.c<CR>
map <buffer> <F3> <Esc>:!g++ %<CR>
map <buffer> <F4> <Esc>:make! clean<CR>
map <buffer> <F5> <Esc>:make!<CR>:cl<CR>
map <buffer> <F6> <Esc>:make run<CR>


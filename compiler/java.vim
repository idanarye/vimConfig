" Vim compiler file
" Compiler: java

if exists("current_compiler")
	finish
endif
let current_compiler = "java"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
	command -nargs=* CompilerSet setlocal <args>
endif

so ~/.vim/bundle/compiler/core_rake.vim

" default errorformat
CompilerSet errorformat=%A%f:%l:\ %m,%C%m


"map <buffer> <F2> <Esc>:silent !ctags *.java<CR>
"map <buffer> <F3> <Esc>:!javac! %<CR>:cl<CR>

"Setup classpath variable:
let g:vjde_lib_path="lib/j2ee.jar:lib/struts.jar:build/classes:./.classFiles/"

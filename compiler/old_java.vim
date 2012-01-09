" Vim compiler file
" Compiler: MSBuild

if exists("current_compiler")
finish
endif
let current_compiler = "java"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
command -nargs=* CompilerSet setlocal <args>
endif

" default errorformat
CompilerSet errorformat=%A%f:%l:\ %m,%C%m

" default make

"CompilerSet makeprg=C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
"CompilerSet makeprg=MSBuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
CompilerSet makeprg=rake

map <buffer> <F2> <Esc>:silent !ctags *.cs<CR>
map <buffer> <F3> <Esc>:!javac! %<CR>:cl<CR>
map <buffer> <F4> <Esc>:make clean<CR>
map <buffer> <F5> <Esc>:make! compile<CR>:cl<CR>
map <buffer> <F6> <Esc>:make! run<CR>
map <buffer> <F7> <Esc>:make! test<CR>

"Setup classpath variable:
let g:vjde_lib_path="lib/j2ee.jar:lib/struts.jar:build/classes:./.classFiles/"

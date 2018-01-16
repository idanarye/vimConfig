" Vim compiler file
" Compiler: MSBuild

if exists("current_compiler")
finish
endif
let current_compiler = "MSBuild"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
command -nargs=* CompilerSet setlocal <args>
endif

" default errorformat
CompilerSet errorformat=\ %#%f(%l\\\,%c):\ %m

" default make

"CompilerSet makeprg=C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true
CompilerSet makeprg=MSBuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true

map <buffer> <F2> <Esc>:silent !"C:\Program Files\ctags58\ctags" *.cs<CR>
map <buffer> <F3> <Esc>:!C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc %<CR>
map <buffer> <F4> <Esc>:make! /target:Clean<CR>
map <buffer> <F5> <Esc>:make!<CR>:cl<CR>
map <buffer> <F6> <Esc>:make! /nologo /target:Run<CR>
map <buffer> <F7> <Esc>:make! /property:DebugType=Full<CR>:cl<CR>
map <buffer> <F8> <Esc>:make! /nologo /target:RunDebugger<CR>
map <buffer> <F9> <Esc>:make! /nologo /target:Publish<CR>

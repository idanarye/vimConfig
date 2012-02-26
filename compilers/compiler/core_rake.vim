" Vim compiler core file
" Compiler: rake core

let current_compiler = "rake"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
	command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=rake\ -s

map <buffer> <F2> <Esc>:silent exe "!".&makeprg." tags"<CR>
map <buffer> <F3> <Esc>:silent exe "!".&makeprg." menu"<CR>
map <buffer> <F4> <Esc>:silent exe "!".&makeprg." clean"<CR>
map <buffer> <F5> <Esc>:make! compile<CR>:cl<CR>
map <buffer> <F6> <Esc>:exe "!".&makeprg." run"<CR>
map <buffer> <F7> <Esc>:exe "!".&makeprg." test"<CR>
"

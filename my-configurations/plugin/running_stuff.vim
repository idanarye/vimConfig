"set makeprg=rake\ -s

nnoremap <F2> :silent exe "!rake -s tags"<CR>
nnoremap <F4> :Erun! rake -s clean<CR>
nnoremap <F5> :Erun! rake -s compile<CR>
nnoremap <F6> :!rake run<CR>
nnoremap <F7> :!rake test<CR>

if has('win32')
	nnoremap <F9> :!%<CR>
	nnoremap <S-F9> :Erun! %<CR>
elseif has('unix')
	nnoremap <F9> :!./%<CR>
	nnoremap <S-F9> :Erun! ./%<CR>
endif

"Deprecated
"if !exists("g:makeshift_systems")
	"let g:makeshift_systems={}
"endif
"call extend(g:makeshift_systems,{
			"\'build.xml': 'ant -q',
			"\})


if !exists("g:erroneous_errorFormatChooserWords")
	let g:erroneous_errorFormatChooserWords={}
endif
call extend(g:erroneous_errorFormatChooserWords,{
			\'javac': '%A%f:%l:%m,%-Z%p^,%-C%.%#',
			\'dmd': '%f(%l): %m',
			\'rdmd': '%f(%l): %m',
			\'ruby': '%f:%l:%m',
			\'rake': function('erroneous_rake#parseErrorOutput'),
			\'ant': function('erroneous_ant#parseErrorOutput'),
			\'make': function('erroneous_make#parseErrorOutput'),
			\})

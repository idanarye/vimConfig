"set makeprg=rake\ -s

"nnoremap <F2> :silent exe '!rake -s tags'<CR>
"nnoremap <F3> :VimShellInteractive rake shell<Cr>
"nnoremap <F4> :Erun! rake -s clean<CR>
"nnoremap <F5> :Erun! rake -s compile<CR>
"nnoremap <F6> :!rake run<CR>
"nnoremap <F7> :!rake test<CR>

nnoremap <F2> :IR tags<CR>
nnoremap <F3> :IR shell<Cr>
nnoremap <F4> :IR clean<CR>
nnoremap <F5> :IR compile<CR>
nnoremap <F6> :IR run<CR>
nnoremap <F7> :IR test<CR>

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
			\'eclim_project_build': '%t:%f:%l:%c:%m',
			\'make': function('erroneous#parseMakeErrorOutput'),
			\'rake': function('erroneous#parseRakeErrorOutput'),
			\'ant': function('erroneous#parseAntErrorOutput'),
			\'mvn': function('erroneous#parseMavenErrorOutput'),
			\})

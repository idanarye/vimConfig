"set makeprg=rake\ -s

"nnoremap <F2> :silent exe '!rake -s tags'<CR>
"nnoremap <F3> :VimShellInteractive rake shell<Cr>
"nnoremap <F4> :Erun! rake -s clean<CR>
"nnoremap <F5> :Erun! rake -s compile<CR>
"nnoremap <F6> :!rake run<CR>
"nnoremap <F7> :!rake test<CR>

"nnoremap <F2> :IR tags<CR>
"nnoremap <F3> :IR shell<Cr>
"nnoremap <F4> :IR clean<CR>
"nnoremap <F5> :IR compile<CR>
"nnoremap <F6> :IR run<CR>
"nnoremap <F7> :IR test<CR>

function s:createIntegrakeShortcut(key,cmd)
	if ''!=a:cmd
		let l:cmd="IR ".a:cmd."<Cr>"
	else
		let l:cmd="IR<Cr>"
	endif
	execute "noremap <M-i>".a:key." :".l:cmd
	execute "inoremap <M-i>".a:key." <C-o>:".l:cmd
	execute "noremap <M-i><M-".a:key."> :".l:cmd
	execute "inoremap <M-i><M-".a:key."> <C-o>:".l:cmd
endfunction

call s:createIntegrakeShortcut('i','')
call s:createIntegrakeShortcut('C','clean')
call s:createIntegrakeShortcut('c','compile')
call s:createIntegrakeShortcut('d','debug')
call s:createIntegrakeShortcut('h','help')
call s:createIntegrakeShortcut('l','load')
call s:createIntegrakeShortcut('m','migrate')
call s:createIntegrakeShortcut('p','print')
call s:createIntegrakeShortcut('R','refresh')
call s:createIntegrakeShortcut('r','run')
call s:createIntegrakeShortcut('s','shell')
call s:createIntegrakeShortcut('T','tags')
call s:createIntegrakeShortcut('t','test')
call s:createIntegrakeShortcut('u','upload')
call s:createIntegrakeShortcut('z','zip')
call s:createIntegrakeShortcut('s','ssh')
call s:createIntegrakeShortcut('S','sync')

noremap <M-i> :IR<Cr>
inoremap <M-i> <C-o>:IR<Cr>

noremap <M-i><Space> :IR<Space>
inoremap <M-i><Space> <C-o>:IR<Space>


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
			\'dub': '%f(%l): %m',
			\'rdmd': '%f(%l): %m',
			\'ruby': '%f:%l:%m',
			\'eclim_project_build': '%t:%f:%l:%c:%m',
			\'make': function('erroneous#parseMakeErrorOutput'),
			\'rake': function('erroneous#parseRakeErrorOutput'),
			\'ant': function('erroneous#parseAntErrorOutput'),
			\'mvn': function('erroneous#parseMavenErrorOutput'),
			\'mcs': '%f(%l\,%c): %m',
			\'csc': '%#%f(%l\,%c): %m',
			\'xbuild': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild3.5': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild32': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild64': function('erroneous#parseXBuildErrorOutput'),
			\'rustc': '%f:%l:%c: %t%*[^:]: %m,%f:%l:%c: %*\d:%*\d %t%*[^:]: %m,%-G%f:%l %s,%-G%*[ ]^,%-G%*[ ]^%*[~],%-G%*[ ]...'
			\})

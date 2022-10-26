"set makeprg=rake\ -s

function! s:createTaskRunningShortcut(key,cmd)
	"For Omnipytent
	if ''!=a:cmd
		let l:cmd="OP ".a:cmd."<Cr>"
	else
		let l:cmd="OP<Cr>"
	endif
	execute "noremap <M-o>".a:key." :".l:cmd
	execute "inoremap <M-o>".a:key." <C-o>:".l:cmd

	"For Moonicipal
	if ''!=a:cmd
		let l:cmd="MC ".a:cmd."<Cr>"
	else
		let l:cmd="MC<Cr>"
	endif
	execute "noremap <M-i>".a:key." :".l:cmd
	execute "inoremap <M-i>".a:key." <C-o>:".l:cmd
endfunction

call s:createTaskRunningShortcut('a','act')
call s:createTaskRunningShortcut('B','bump')
call s:createTaskRunningShortcut('b','build')
call s:createTaskRunningShortcut('C','clean')
call s:createTaskRunningShortcut('c','check')
call s:createTaskRunningShortcut('<C-c>','configure')
call s:createTaskRunningShortcut('<M-c>','command')
call s:createTaskRunningShortcut('d','debug')
call s:createTaskRunningShortcut('D','dump')
call s:createTaskRunningShortcut('<C-d>','doc')
call s:createTaskRunningShortcut('e','execute')
call s:createTaskRunningShortcut('E','explore')
call s:createTaskRunningShortcut('<M-d>','deploy')
call s:createTaskRunningShortcut('f','fetch')
call s:createTaskRunningShortcut('F','fix')
call s:createTaskRunningShortcut('<C-f>','find')
call s:createTaskRunningShortcut('G','generate')
call s:createTaskRunningShortcut('g','go')
call s:createTaskRunningShortcut('h','help')
call s:createTaskRunningShortcut('i','install')
call s:createTaskRunningShortcut('I','init')
call s:createTaskRunningShortcut('k','kill')
call s:createTaskRunningShortcut('l','load')
call s:createTaskRunningShortcut('L','launch')
call s:createTaskRunningShortcut('<C-l>','log')
call s:createTaskRunningShortcut('m','migrate')
call s:createTaskRunningShortcut('p','prompt')
call s:createTaskRunningShortcut('q','query')
call s:createTaskRunningShortcut('R','refresh')
call s:createTaskRunningShortcut('r','run')
call s:createTaskRunningShortcut('<C-r>','reset')
call s:createTaskRunningShortcut('s','shell')
call s:createTaskRunningShortcut('<C-s>','ssh')
call s:createTaskRunningShortcut('S','sync')
call s:createTaskRunningShortcut('t','test')
call s:createTaskRunningShortcut('<C-t>','build_tests')
call s:createTaskRunningShortcut('T','tags')
call s:createTaskRunningShortcut('u','upload')
call s:createTaskRunningShortcut('U','update')
call s:createTaskRunningShortcut('v','view')
call s:createTaskRunningShortcut('w','wipe')
call s:createTaskRunningShortcut('W','wipe_all')
call s:createTaskRunningShortcut('z','zip')

for s:digit in range(10)
	call s:createTaskRunningShortcut(string(s:digit), ':' . s:digit)
endfor

noremap <M-i> :MC<Cr>
inoremap <M-i> <C-o>:MC<Cr>

noremap <M-i><Space> :MC<Space>
inoremap <M-i><Space> <C-o>:MC<Space>

noremap <M-o><Space> :OP<Space>
inoremap <M-o><Space> <C-o>:OP<Space>

noremap <M-o> :OP<Cr>
inoremap <M-o> <C-o>:OP<Cr>


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

let g:erroneous_dontUseRuby = 1
if !exists("g:erroneous_errorFormatChooserWords")
	let g:erroneous_errorFormatChooserWords={}
endif
call extend(g:erroneous_errorFormatChooserWords,{
			\'javac': '%A%f:%l:%m,%-Z%p^,%-C%.%#',
			\'dmd': '%f(%l): %m',
			\'ldc': '%f(%l): %m',
			\'ldc2': '%f(%l): %m',
			\'dub': '%f(%l): %m,%f(%l\,%c): %m',
			\'rdmd': '%f(%l): %m',
			\'ruby': '%f:%l:%m',
			\'eclim_project_build': '%t:%f:%l:%c:%m',
			\'make': function('erroneous#parseMakeErrorOutput'),
			\'rake': function('erroneous#parseRakeErrorOutput'),
			\'ant': function('erroneous#parseAntErrorOutput'),
			\'mvn': function('erroneous#parseMavenErrorOutput'),
			\'gradle': '%A%f:%l:%m,%-Z%p^,%-C%.%#,%t: %f: (%l\, %c): %m',
			\'mcs': '%f(%l\,%c): %m',
			\'csc': '%#%f(%l\,%c): %m',
			\'xbuild': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild3.5': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild32': function('erroneous#parseXBuildErrorOutput'),
			\'MSBuild64': function('erroneous#parseXBuildErrorOutput'),
			\'waf': function('erroneous#parseWafErrorOutput'),
			\})

let g:erroneous_errorFormatChooserWords.rustc = ''
			\ . '%f:%l:%c: %t%*[^:]: %m,'
			\ . '%f:%l:%c: %*\d:%*\d %t%*[^:]: %m,'
			\ . '%-G%f:%l %s,'
			\ . '%-G%*[ ]^,'
			\ . '%-G%*[ ]^%*[~],'
			\ . '%-G%*[ ]...,'
			\ . '%-G,'
			\ . '%-Gerror: aborting %.%#,'
			\ . '%-Gerror: Could not compile %.%#,'
			\ . '%Eerror: %m,'
			\ . '%Eerror[E%n]: %m,'
			\ . '%Wwarning: %m,'
			\ . '%Inote: %m,'
			\ . '%C %#--> %f:%l:%c'
let g:erroneous_errorFormatChooserWords.cargo = g:erroneous_errorFormatChooserWords.rustc . ','
			\ . '%-G%\s%#Downloading%.%#,'
			\ . '%-G%\s%#Compiling%.%#,'
			\ . '%-G%\s%#Finished%.%#,'
			\ . '%-G%\s%#error: Could not compile %.%#,'
			\ . '%-G%\s%#To learn more\,%.%#'


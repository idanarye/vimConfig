if has('win32')
	if exists('g:snippets_dir')
		let g:snippets_dir=join(map(split(g:snippets_dir,','),'substitute(v:val,"\\v\\\\$","","")'),',')
	endif
endif

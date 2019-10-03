for s:colorscheme in ['tortus', 'torte']
    if !empty(globpath(&runtimepath, printf('colors/%s.vim', s:colorscheme)))
	execute 'colorscheme ' . s:colorscheme
	finish
    endif
endfor

if has('termguicolors')
	if $ASCIINEMA_REC == '1'
		set notermguicolors
	else
		set termguicolors
	endif
endif
try
	" color challenger_deep
catch
endtry
let g:airline_theme='solarized'

hi def DarkYellow guifg=#BBBB00

set foldlevel=1048576

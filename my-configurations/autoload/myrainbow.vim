"shamelessly stolen from the rainbow#toggle function
function! myrainbow#toggle()
	if exists('b:active')
		cal rainbow#inactivate()
	else
		cal rainbow#load()
	endif
endfunction

function! CurDate()
	return strftime("%Y-%m-%d",localtime())
endfunction

function! CurTime()
	return strftime("%Y-%m-%d %H:%M:%S",localtime())
endfunction

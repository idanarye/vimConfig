function! s:FindOpenerIndentation(lineNumber)
	let l:closers=matchstr(getline(a:lineNumber),'^\s*[)\]}]')
	call cursor(a:lineNumber,len(l:closers))
	let l:close=l:closers[len(l:closers)-1]
	if l:close==')'
		let l:open='('
	elseif l:close==']'
		let l:open='\['
		let l:close='\]'
	elseif l:close=='}'
		let l:open='{'
	endif
	"Shamelessly copied from the VimClojure indentation script
	let l:result=searchpairpos(l:open,'',l:close,'bWn','myutil#SynIdName()!~"racketString\\d"')
	return l:result[1]-1
endfunction

function! mylispindent#lispIndent()
	if 0==match(getline('.'),'^\s*[)\]}]')
		return s:FindOpenerIndentation(line('.'))
	else
		return lispindent(line('.'))
	endif
endfunction


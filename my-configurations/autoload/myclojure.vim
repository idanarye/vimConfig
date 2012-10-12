function! myclojure#evalCommand(command)
	let result = vimclojure#ExecuteNailWithInput("Repl", a:command,
				\ "-r")

	let resultBuffer = g:vimclojure#ClojureResultBuffer.New("user")
	call resultBuffer.showOutput(result)
	wincmd p
endfunction

function! s:FindOpenerIndentation()
	"let l:closers=matchstr(getline('.'),'^\s*[)\]}]*')
	let l:closers=matchstr(getline('.'),'^\s*[)\]}]')
	call cursor(line('.'),len(l:closers))
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
	let l:result=searchpairpos(l:open,'',l:close,'bWn','vimclojure#util#SynIdName()!~"clojureParen\\d"')
	return l:result[1]-1
endfunction

function! myclojure#clojureIndent()
	if 0==match(getline('.'),'^\s*[)\]}]')
		return s:FindOpenerIndentation()
	else
		return GetClojureIndent()
	endif
endfunction

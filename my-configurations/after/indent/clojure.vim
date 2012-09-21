function! s:FindOpenerIndentation(open,close)
	call cursor(line('.'),1)
	"Shamelessly copied from the VimClojure indentation script
	let l:result=searchpairpos(a:open,'',a:close,'bWn','vimclojure#util#SynIdName()!~"clojureParen\\d"')
	return l:result[1]-1
endfunction

function! MyClojureIndent()
	if 0==match(getline('.'),'^\s*)')
		return s:FindOpenerIndentation('(',')')
	elseif 0==match(getline('.'),'^\s*]')
		return s:FindOpenerIndentation('[',']')
	elseif 0==match(getline('.'),'^\s*}')
		return s:FindOpenerIndentation('{','}')
	else
		return GetClojureIndent()
	endif
endfunction

function! myclojure#evalCommand(command,...)
	if a:0>0&&a:1
		call vimclojure#ExecuteNailWithInput("Repl", "(require :reload-all '".b:vimclojure_namespace.")", "-r")
	endif
	let result = vimclojure#ExecuteNailWithInput("Repl", a:command,
				\ "-r")

	let resultBuffer = g:vimclojure#ClojureResultBuffer.New("user")
	call resultBuffer.showOutput(result)
	wincmd p
endfunction

function! myclojure#runFile(fileName)
	"shamelessly stolen from the vimclojure#ExecuteNailWithInput function
	"
	let cmdline = vimclojure#ShellEscapeArguments(
				\ [g:vimclojure#NailgunClient,
				\   '--nailgun-server', g:vimclojure#NailgunServer,
				\   '--nailgun-port', g:vimclojure#NailgunPort,
				\   'vimclojure.Nail', "Repl", "-r"]
				\ + a:000)
	let cmd = join(cmdline, " ") . " <" . a:fileName
	" Add hardcore quoting for Windows
	if has("win32") || has("win64")
		let cmd = '"' . cmd . '"'
	endif

	let output = system(cmd)

	if v:shell_error
		throw "Error executing Nail! (" . v:shell_error . ")\n" . output
	else
		execute "let result = " . substitute(output, '\n$', '', '')
		let resultBuffer = g:vimclojure#ClojureResultBuffer.New("user")
		call resultBuffer.showOutput(result)
		wincmd p
	endif
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

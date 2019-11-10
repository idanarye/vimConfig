function! tabfzf#run() abort
    let l:echoScriptLines = ['case $1 in']
    let l:tabLines = []
    for l:tabNr in range(1, tabpagenr('$'))
	call add(l:echoScriptLines, l:tabNr . ')')
	let l:bufNrs = tabpagebuflist(l:tabNr)
	" let l:buffers = map(l:buffers, 'buffer_name(v:val)')
	let l:lastParts = []
	for l:bufNr in l:bufNrs
	    let l:bufName = buffer_name(l:bufNr)
	    if empty(l:bufName)
		continue
	    endif
	    call add(l:echoScriptLines, 'echo ' . shellescape(l:bufName))
	    let l:bufType = getbufvar(l:bufNr, '&buftype')
	    if (empty(l:bufType) || l:bufType == 'terminal')
		call add(l:lastParts, split(l:bufName, '/')[-1])
	    else
		call add(l:lastParts, l:bufName)
	    endif
	endfor
	call add(l:tabLines, printf('%s %s', l:tabNr, join(l:lastParts, ' ')))
	call add(l:echoScriptLines, ';;')
    endfor
    call add(l:echoScriptLines, 'esac')
    let l:echoScript = join(l:echoScriptLines, "\n")
    let l:preview = printf('bash -ce %s -- {1}', shellescape(l:echoScript))
    call fzf#run({
		\ 'source': l:tabLines,
		\ 'options': '--preview ' . shellescape(l:preview),
		\ 'sink': function('s:goToTab'),
		\ 'down': '~40%',
		\ })
endfunction

function! s:goToTab(tabNr) abort
    execute 'tabnext ' . split(a:tabNr, ' ')[0]
endfunction

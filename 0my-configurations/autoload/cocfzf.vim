function! cocfzf#codeAction() abort
    let l:quickfixes = CocAction('quickfixes')
	if empty(l:quickfixes)
		echo 'No quickfixes'
		return
	endif
	call fzf#run({
				\ 'source': map(copy(l:quickfixes), {i, q -> i . ' '. q.title}),
				\ 'sink': function('s:codeActionSink', [l:quickfixes]),
				\ 'options': '--with-nth 2..',
				\ })
endfunction

function! s:codeActionSink(quickfixes, chosen) abort
	let l:chosenIndex = str2nr(a:chosen.split(a:chosen)[0])
	let l:chosen = a:quickfixes[l:chosenIndex]
	call CocActionAsync('doCodeAction', l:chosen)
endfunction

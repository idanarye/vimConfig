
function! mypy#runFlake8(filename)
	if empty(a:filename)
		let l:flakeResult = systemlist('flake8 -', getline(0, '$'))
	else
		let l:flakeResult = systemlist('flake8 ' . shellescape(a:filename))
	endif
	let l:qfItems = []
	for l:line in l:flakeResult
		echo l:line
		let l:match = matchlist(l:line, '\v\C^(.*):(\d+):(\d+): (\w)(\d+) (.*)$')
		if !empty(l:match)
			let l:item = {}

			if l:match[1] == 'stdin'
				let l:item.bufnr = bufnr('')
			else
				let l:item.filename = l:match[1]
			endif

			let l:item.lnum = l:match[2]
			let l:item.col = l:match[3]
			let l:item.type = l:match[4]
			let l:item.nr = l:match[5]
			let l:item.text = l:match[6]

			call add(l:qfItems, l:item)
		endif
	endfor
	call setqflist(l:qfItems)
endfunction

let s:python2BuiltinsNotInPython3 = [
			\ 'StandardError',
			\ 'apply',
			\ 'basestring',
			\ 'buffer',
			\ 'cmp',
			\ 'coerce',
			\ 'execfile',
			\ 'file',
			\ 'intern',
			\ 'long',
			\ 'raw_input',
			\ 'reduce',
			\ 'reload',
			\ 'unichr',
			\ 'unicode',
			\ 'xrange']

function! mypy#runFlake8(filename)
	let l:flakeCmd = 'flake8'
	let l:flakeCmd .= ' --max-line-length=130'
	let l:flakeCmd .= ' --ignore=F403'
	if empty(a:filename)
		let l:flakeResult = systemlist(l:flakeCmd . ' -', getline(0, '$'))
	else
		let l:flakeResult = systemlist(l:flakeCmd . ' ' . shellescape(a:filename))
	endif
	let l:qfItems = []
	for l:line in l:flakeResult
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

			if l:item.nr == 821
				let l:undefinedName = matchstr(l:item.text, "\\v['\"]\\zs\\w+\\ze['\"]$")
				if 0 <= index(s:python2BuiltinsNotInPython3, l:undefinedName)
					continue
				endif
			endif
			echo l:line
			call add(l:qfItems, l:item)
		endif
	endfor
	call setqflist(l:qfItems)
endfunction

function! mypy#runAutopep8() abort
	let l:autopep8Cmd = 'autopep8 -'
	let l:autopep8Cmd .= ' --max-line-length=130'
	let l:autopep8Cmd .= ' --ignore=F403'

	let l:lnum = v:lnum
	let l:count = v:count
	let l:autopep8Cmd .= printf(' --line-range %s %s', l:lnum, l:lnum + l:count - 1)

	let l:lines = getline(1, '$')
	let l:countAfter = len(l:lines) - l:lnum - l:count + 1
	let l:formattedLines = systemlist(l:autopep8Cmd, l:lines)
	let l:formattedLines = l:formattedLines[l:lnum - 1 : len(l:formattedLines) - l:countAfter - 1]

	if l:count > len(l:formattedLines)
		execute (l:lnum + len(l:formattedLines)).','.(l:lnum + l:count - 1) 'delete'
	elseif l:count < len(l:formattedLines)
		call append(l:lnum + l:count - 1, repeat([''], len(l:formattedLines) - l:count))
	endif

	call setline(l:lnum, l:formattedLines)
endfunction

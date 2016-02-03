if has('nvim')

	let g:guifontFace = get(g:, 'guifontFace', 'DejaVu Sans Mono')
	let g:guifontSize = get(g:, 'guifontSize', 14)
	function! s:fontSize(size)
		if '' == a:size
			echo 'Current font size: '.g:guifontSize
			return
		elseif '+' == a:size[0] || '-' == a:size[0]
			let g:guifontSize += str2nr(a:size)
		else
			let g:guifontSize = str2nr(a:size)
		endif
		call rpcnotify(0, 'Gui', 'SetFont', g:guifontFace.':h'.g:guifontSize)
	endfunction
else
	function! s:fontSize(size)
		let l:newSize = str2nr(a:size)
		let l:currentFont = &guifont
		if empty(l:currentFont)
			let l:currentFont = getfontname()
		endif
		if empty(l:currentFont)
			let l:currentFont = 'Monospace 10'
		endif
		let l:fontSizeStartIndex = match(l:currentFont, '\v\s\d+$')
		let l:currentFontFace = l:currentFont[:(l:fontSizeStartIndex)]
		let l:currentFontSize = str2nr(l:currentFont[(l:fontSizeStartIndex):])
		if '' == a:size
			echo 'Current font size: '.l:currentFontSize
		elseif '+' == a:size[0] || '-' == a:size[0]
			let &guifont = l:currentFontFace.(l:currentFontSize + l:newSize)
		else
			let &guifont = l:currentFontFace.l:newSize
		endif
	endfunction
end

command! -nargs=? FontSize call s:fontSize(<q-args>)

nnoremap <M--> :FontSize -1<Cr>
nnoremap <M-=> :FontSize +1<Cr>
nnoremap <M-0> :FontSize 14<Cr>

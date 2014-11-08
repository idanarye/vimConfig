function! s:fontSize(size)
	let l:newSize = str2nr(a:size)
	let l:currentFont = getfontname()
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

command! -nargs=? FontSize call s:fontSize(<q-args>)

nnoremap <M--> :FontSize -1<Cr>
nnoremap <M-=> :FontSize +1<Cr>
nnoremap <M-0> :FontSize 10<Cr>

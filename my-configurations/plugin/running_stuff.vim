
nnoremap <F2> :silent exe "!".&makeprg." tags"<CR>
nnoremap <F4> :Emake! clean<CR>
nnoremap <F5> :Emake! compile<CR>
nnoremap <F6> :Erun! run<CR>
nnoremap <F7> :Erun! test<CR>

if has('win32')
	nnoremap <F9> :Erun %<CR>
elseif has('unix')
	nnoremap <F9> :Erun ./%<CR>
endif


if !exists("g:erroneous_errorFormatChooserWords")
	let g:erroneous_errorFormatChooserWords={}
endif
call extend(g:erroneous_errorFormatChooserWords,{
			\'java': '%A%f:%l:%m,%-Z%p^,%-C%.%#',
			\'dmd': '%f(%l): %m',
			\'rdmd': '%f(%l): %m',
			\'ruby': '%f:%l:%m',
			\'rake': 0,
			\})

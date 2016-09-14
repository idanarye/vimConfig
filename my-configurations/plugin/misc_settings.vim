set completeopt-=preview
set completeopt-=longest
set selection=inclusive
set breakindent


" Configure Unite

" Like ctrlp.vim settings.
call unite#custom#profile('default', 'context', {
			\   'start_insert': 1,
			\   'winheight': 10,
			\   'direction': 'botright',
			\ })

call unite#filters#matcher_default#use(['matcher_fuzzy'])

if executable('ag')
	" Use ag (the silver searcher)
	" https://github.com/ggreer/the_silver_searcher
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts =
				\ '-i --vimgrep --hidden --ignore ' .
				\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
endif

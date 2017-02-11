set completeopt-=preview
set completeopt-=longest
set selection=inclusive
set breakindent

if has('nvim')
	let $EDITOR = 'nvim'
endif


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


" Distable rust-racer default mappings - I'll add them in a ftplugin
let g:racer_no_default_keymappings = 1

" Configure NERDCommenter
function! s:setNerdCommenterOptions() abort
	try
		if b:NERDCommenterDelims.left =~ '\v $'
			let g:NERDSpaceDelims = 0
		else
			let g:NERDSpaceDelims = 1
		endif
	catch
	endtry
endfunction
autocmd BufEnter,BufRead,Filetype * call s:setNerdCommenterOptions()

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

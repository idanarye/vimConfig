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


" Configure bookmarks
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" GTK setup
if exists('g:GtkGuiLoaded')
    if str2nr($NVIM_GTK_NO_HEADERBAR)
		call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
	endif
endif

" Vimtex setup
let g:tex_flavor = 'latex'

let g:git_messenger_no_default_mappings = v:true


set signcolumn=yes

let g:doge_mapping = "<Leader>D"
let g:doge_mapping_comment_jump_forward = "<C-j>"
let g:doge_mapping_comment_jump_backward = "<C-k>"

set diffopt=filler,internal,algorithm:histogram,indent-heuristic

let g:context_enabled = 0

set inccommand=nosplit

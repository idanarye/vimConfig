let g:ale_set_loclist = 0
let g:ale_sign_column_always = 1
let g:ale_python_flake8_args = '--max-line-length=130 --ignore=F403,F999'
let g:ale_rust_cargo_use_check = 1

function! s:aleSetQfList() abort
	let l:list = ale#engine#GetLoclist(bufnr(''))
	if !empty(l:list)
		try
			echohl ErrorMsg
			echo 'ALE found' len(l:list) 'problems'
			echohl WarningMsg
			for l:entry in l:list
				if type(l:entry) == type('')
					echo l:entry
				else
					echo printf('Line %s: %s', l:entry.lnum, l:entry.text)
				endif
			endfor
		finally
			echohl None
		endtry
	endif
	call setqflist(l:list)
endfunction
command! ALESetQfList call s:aleSetQfList()

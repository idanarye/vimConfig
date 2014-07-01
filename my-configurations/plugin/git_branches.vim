function! s:GitStashComplete(argLead,cmdLine,cursorPos)
	if a:argLead=~'^-'
		return [] "currently not completing flags
	endif
	let l:res=split(system('git stash list'),"\n")
	let l:res=map(l:res,'split(v:val,":")[0]')
	let l:res=['apply','list']+l:res
	let l:cutUntil=len(a:argLead)-1
	if 0<=l:cutUntil
		let l:res=filter(l:res,'v:val[:(l:cutUntil)]==a:argLead')
	endif
	return l:res
endfunction


function! s:gitAction(action,args)
	exec 'Git '.a:action.' '.a:args
	try
		silent windo if ''==&buftype | edit | endif
	catch
	endtry
endfunction

autocmd User Fugitive command! -complete=customlist,s:GitStashComplete -nargs=? Gstash call s:gitAction('stash',<q-args>)

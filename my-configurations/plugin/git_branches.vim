function! s:GitBranchComplete(argLead,cmdLine,cursorPos)
	if a:argLead=~'^-'
		return [] "currently not completing flags
	endif
	let l:res=split(system('git branch --list'),"\n")
	let l:res=map(l:res,'v:val[2:]')
	let l:cutUntil=len(a:argLead)-1
	if 0<=l:cutUntil
		let l:res=filter(l:res,'v:val[:(l:cutUntil)]==a:argLead')
	endif
	return l:res
endfunction

function! s:gitAction(action,args)
	exec 'Git '.a:action.' '.a:args
	try
		silent bufdo edit
	catch
	endtry
endfunction

command! -complete=customlist,s:GitBranchComplete -nargs=? Gbranch call s:gitAction('branch',<q-args>)
command! -complete=customlist,s:GitBranchComplete -nargs=? Gcheckout call s:gitAction('checkout',<q-args>)
command! -complete=customlist,s:GitBranchComplete -nargs=? Gmerge call s:gitAction('merge',<q-args>)


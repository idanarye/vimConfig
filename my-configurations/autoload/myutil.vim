"
"Shamelessly copied from the VimClojure util scripts
function! myutil#SynIdName()
	return synIDattr(synID(line("."), col("."), 0), "name")
endfunction

function! myutil#runRangeCommandOnEntireBufferAndRestoreCurosr(cmd) abort
    let l:curpos = getcurpos()
    try
        execute '%'.a:cmd
    finally
        call setpos('.', l:curpos)
    endtry
endfunction

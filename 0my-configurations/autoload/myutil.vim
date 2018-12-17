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

function! myutil#invokeCompletion(completeFunc) abort
    let l:start = a:completeFunc(1, 0)
    let l:base = getline('.')[(l:start):(col('.') - 2)]
    call complete(l:start + 1, a:completeFunc(0, l:base))
    return ''
endfunction

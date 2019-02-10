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

function! s:hasSigns(bufnr) abort
    let l:signcolumn = getbufvar(a:bufnr, '&l:signcolumn')
    if l:signcolumn == 'yes'
        return v:true
    elseif l:signcolumn == 'no'
        return v:false
    else
        return execute('sign place buffer=' . a:bufnr) =~ 'Signs for'
    endif
endfunction

function! myutil#fitWinWidth() abort
    let l:targetWidth = max(map(getline(0, '$'), 'len(v:val)'))
    let l:signs = execute('sign list')
    if s:hasSigns(bufnr(''))
        " let l:targetWidth += max(map(split(execute('sign list'), '\n'), 'len(matchstr(v:val, "text=\\zs\\S*"))'))
        let l:targetWidth += 2
    endif
    execute l:targetWidth.'wincmd |'
endfunction

function! myutil#diffOnly() abort
    if !&diff
        echoerr 'diffOnly called from a non-diff window'
        return
    endif
    let l:win = 1
    while l:win <= winnr('$')
        if l:win != winnr() && getwinvar(l:win, '&diff')
            execute l:win . 'wincmd c'
        else
            let l:win += 1
        endif
    endwhile
endfunction

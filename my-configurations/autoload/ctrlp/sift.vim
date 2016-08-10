let s:var = {
            \ 'init': 'ctrlp#sift#init()',
            \ 'accept': 'ctrlp#sift#accept',
            \ 'lname': 'sift',
            \ 'sname': 'sift',
            \ 'type': 'line',
            \ 'sort': 0,
            \ 'specinput': 0,
            \ }


if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    call filter(g:ctrlp_ext_vars, 'v:val.sname != s:var.sname')
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:var)
else
    let g:ctrlp_ext_vars = [s:var]
endif
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#sift#init()
    let l:pattern = input('sift> ')
    if empty(l:pattern)
        return []
    endif
    return systemlist('sift --line-number --recursive --binary-skip . --regexp='.shellescape(l:pattern))
endfunction

function! ctrlp#sift#accept(mode, str)
    let l:match = matchlist(a:str, '\v^(.{-}):(\d+):(.*)$')
    if empty(l:match)
        return
    endif
    let l:file = l:match[1]
    let l:line = str2nr(l:match[2])
    let l:text = l:match[3]

    call ctrlp#acceptfile(a:mode, l:file)

    call cursor(l:line, 0)
    silent! normal! zvzz
endfunction

function! ctrlp#sift#id()
    return s:id
endfunction

setlocal textwidth=0

" function! s:addXClipTraces()
    " if !empty(getline('.'))
        " call append('.', '')
        " call cursor(line('.') + 1, 0)
    " endif
    " call setline('.', '{noformat}')
    " read !xclip-traces
    " call append('.', '{noformat}')
    " call cursor(line('.') + 1, 0)
" endfunction

" command! -buffer XClipTraces call s:addXClipTraces()
" nnoremap <buffer> <LocalLeader>t :XClipTraces<Cr>

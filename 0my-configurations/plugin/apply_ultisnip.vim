function! s:ApplyUltisnipAfterCompletion() abort
    if !has_key(v:completed_item, 'word')
        " Completion was aborted midway
        return
    endif
    if v:completed_item.word =~ '\n'
        " TODO: support multiline snippets?
        return
    endif
    if v:completed_item.word !~ '\V${\[^{]\.\*}'
        " Not an ultisnip snippet
        return
    endif

    let l:column = getcurpos()[2]
    let l:snip_start = l:column - len(v:completed_item.word) - 1
    let l:snip_end = l:column - 2
    let l:line = getline('.')
    let l:snippet_in_buffer = l:line[l:snip_start : l:snip_end]
    if l:snippet_in_buffer != v:completed_item.word
        echoerr 'expected' string(v:completed_item.word) 'got' string(l:snippet_in_buffer)
        return
    endif

    let l:line_without_snippet = l:line[: l:snip_start - 1] . l:line[l:snip_end + 1 :]
    call setline('.', l:line_without_snippet)
    call cursor('.', l:column - len(l:snippet_in_buffer))
    call UltiSnips#Anon(l:snippet_in_buffer)
endfunction

augroup apply_ultisnip
    autocmd!
    autocmd CompleteDone * call s:ApplyUltisnipAfterCompletion()
augroup END


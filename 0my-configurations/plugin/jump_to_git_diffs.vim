function! s:getDiffLines() abort
    let l:filename = expand('%')
    let l:gitCmd = join([
                \ 'git diff --unified=0 --',
                \ shellescape(l:filename),
                \ '| grep "^@@ " | cut -d\  -f3 | sed "s/^[^0-9]*\([0-9]\+\).*/\1/"',
                \ ], ' ')
    return map(systemlist(l:gitCmd), 'str2nr(v:val)')
endfunction

function! s:jumpFirst() abort
    let l:diffLines = s:getDiffLines()
    if !empty(l:diffLines)
        execute l:diffLines[0]
    endif
endfunction

function! s:jumpBackward() abort
    let l:diffLines = s:getDiffLines()
    let l:currentLine = line('.')
    let l:prevLine = 0
    for l:line in l:diffLines
        if l:currentLine <= l:line
            if 0 < l:prevLine
                execute l:prevLine
            endif
            return
        endif
        let l:prevLine = l:line
    endfor
endfunction

function! s:jumpForward() abort
    let l:diffLines = s:getDiffLines()
    let l:currentLine = line('.')
    for l:line in l:diffLines
        if l:currentLine < l:line
            execute l:line
            return
        endif
    endfor
endfunction

function! s:jumpLast() abort
    let l:diffLines = s:getDiffLines()
    if !empty(l:diffLines)
        execute l:diffLines[-1]
    endif
endfunction

nnoremap [G :call <SID>jumpFirst()<Cr>
nnoremap [g :call <SID>jumpBackward()<Cr>
nnoremap ]g :call <SID>jumpForward()<Cr>
nnoremap ]G :call <SID>jumpLast()<Cr>

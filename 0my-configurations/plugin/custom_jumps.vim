function! s:jumpFirst(diffLines) abort
    if !empty(a:diffLines)
        execute a:diffLines[0]
    endif
endfunction

function! s:jumpBackward(diffLines) abort
    let l:currentLine = line('.')
    let l:prevLine = 0
    for l:line in a:diffLines
        if l:currentLine <= l:line
            if 0 < l:prevLine
                execute l:prevLine
            endif
            return
        endif
        let l:prevLine = l:line
    endfor
    if 0 < l:prevLine
        execute l:prevLine
    endif
endfunction

function! s:jumpForward(diffLines) abort
    let l:currentLine = line('.')
    for l:line in a:diffLines
        if l:currentLine < l:line
            execute l:line
            return
        endif
    endfor
endfunction

function! s:jumpLast(diffLines) abort
    if !empty(a:diffLines)
execute a:diffLines[-1]
    endif
endfunction

function! s:createMapping(char, Source) abort
    for [l:map, l:Func] in [
                \ ['[' . toupper(a:char), function('s:jumpFirst')],
                \ ['[' . a:char, function('s:jumpBackward')],
                \ [']' . toupper(a:char), function('s:jumpLast')],
                \ [']' . a:char, function('s:jumpForward')],
                \]
        execute printf('nnoremap %s :call %s(%s())<Cr>', l:map, l:Func, a:Source)
    endfor
endfunction

function! s:getDiffLines() abort
    let l:filename = expand('%')
    let l:gitCmd = join([
                \ 'git diff --unified=0 --',
                \ shellescape(l:filename),
                \ '| grep "^@@ " | cut -d\  -f3 | sed "s/^[^0-9]*\([0-9]\+\).*/\1/"',
                \ ], ' ')
    return map(systemlist(l:gitCmd), 'str2nr(v:val)')
endfunction
call s:createMapping('g', function('s:getDiffLines'))

function! s:getDiagnosticLines() abort
    let l:lines = []
    let l:thisBufname = bufname()
    for l:entry in CocAction('diagnosticList')
        if bufname(l:entry.file) == l:thisBufname
            call add(l:lines, l:entry.lnum)
        endif
    endfor
    return uniq(sort(l:lines))
endfunction
call s:createMapping('d', function('s:getDiagnosticLines'))

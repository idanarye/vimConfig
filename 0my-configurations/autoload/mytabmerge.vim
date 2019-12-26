function! s:tabsInfo() abort
    let l:result = []
    for l:line in split(execute('tabs'), '\n')
        let l:m = matchlist(l:line, '\v^Tab page (\d+)$')
        if !empty(l:m)
            let l:tabData = {
                        \ 'nr': str2nr(l:m[1]),
                        \ 'windows': [],
                        \ 'current': v:false,
                        \ }
            call add(l:result, l:tabData)
            continue
        endif
        let l:m = matchlist(l:line, '\v^([> ])   (.*)$')
        if l:m[1] == '>'
            let l:tabData.current = v:true
        endif
        call add(l:tabData.windows, l:m[2])
    endfor
    return l:result
endfunction

function! s:runTabMerge(choice) abort
    execute 'Tabmerge ' . split(a:choice)[0]
endfunction

function! mytabmerge#fzfAndTabmerge() abort
    let l:tabsInfo = s:tabsInfo()
    let l:lines = []
    for l:tab in l:tabsInfo
        if !l:tab.current
            call add(l:lines, printf("%s\tTab %s: %s", l:tab.nr, l:tab.nr, join(l:tab.windows, ' ')))
        endif
    endfor
    if empty(l:lines)
        echo 'This is the only tab'
        return
    endif
    echo fzf#run({
                \ 'source': l:lines,
                \ 'options': [
                \     '--delimiter=\t',
                \     '--with-nth=2..',
                \ ],
                \ 'sink': function('s:runTabMerge'),
                \})
endfunction

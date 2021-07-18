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
        let l:m = matchlist(l:line, '\v^([> #])   (.*)$')
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

function! tabops#fzfAndTabmerge() abort
    let l:tabsInfo = s:tabsInfo()
    let l:lines = []
    let l:tabsAfterCurrent = 0
    for l:tab in l:tabsInfo
        if l:tab.current
            let l:tabsAfterCurrent = 0
        else
            call add(l:lines, printf("%s\tTab %s: %s", l:tab.nr, l:tab.nr, join(l:tab.windows, ' ')))
            let l:tabsAfterCurrent += 1
        endif
    endfor
    if empty(l:lines)
        echo 'This is the only tab'
        return
    endif
    echo fzf#run({
                \ 'source': l:lines,
                \ 'options': [
                \     '--no-sort',
                \     '--cycle',
                \     '--tac',
                \     '--delimiter=\t',
                \     '--with-nth=2..',
                \ ],
                \ 'down': '20%',
                \ 'sink': function('s:runTabMerge'),
                \})
    call jobsend(b:terminal_job_id, repeat("\<C-k>", l:tabsAfterCurrent - 1))
endfunction

function! s:runTabJump(choice) abort
    execute 'tabnext ' . split(a:choice)[0]
endfunction

function! tabops#fzfAndTabjump() abort
    let l:tabsInfo = s:tabsInfo()
    let l:lines = []
    let l:tabsAfterCurrent = 0
    for l:tab in l:tabsInfo
        call add(l:lines, printf("%s\tTab %s: %s", l:tab.nr, l:tab.nr, join(l:tab.windows, ' ')))
        if l:tab.current
            let l:tabsAfterCurrent = 0
        else
            let l:tabsAfterCurrent += 1
        endif
    endfor
    if empty(l:lines)
        echo 'This is the only tab'
        return
    endif
    let g:myfuz = fzf#run({
                \ 'source': l:lines,
                \ 'options': [
                \     '--no-sort',
                \     '--cycle',
                \     '--tac',
                \     '--delimiter=\t',
                \     '--with-nth=2..',
                \ ],
                \ 'down': '20%',
                \ 'sink': function('s:runTabJump'),
                \})
    call jobsend(b:terminal_job_id, repeat("\<C-k>", l:tabsAfterCurrent))
endfunction

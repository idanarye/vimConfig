let g:unstack_mapkey = "<Leader>S"
let g:unstack_showsigns = 0
let g:unstack_populate_quickfix = 1
let g:unstack_open_tab = 0

let s:javaExtractor = {}

function! s:javaExtractor.scoreMatch(methodParts, pathParts) abort dict
    let l:max = 0
    for l:start in range(len(a:pathParts))
        let l:slice = a:pathParts[l:start:]
        for l:i in range(min([len(l:slice), len(a:methodParts)]))
            if l:slice[l:i] != a:methodParts[l:i]
                break
            endif
        endfor
        if l:max < l:i
            let l:max = l:i
        endif
    endfor
    return l:max
endfunction

function! s:javaExtractor.resolveFilePath(methodFullName, filename) abort dict
    let l:methodParts = split(a:methodFullName, '\V.')
    let l:bestPath = ''
    let l:bestScore = 0
    for l:path in glob('**/' . a:filename, 1, 1)
        let l:pathParts = split(substitute(l:path, '\v\.java$', '', ''), '\v[\\/]')
        let l:score = self.scoreMatch(l:methodParts, l:pathParts)
        if l:bestScore < l:score
            let l:bestPath = l:path
            let l:bestScore = l:score
        endif
    endfor
    return l:bestPath
endfunction

function! s:javaExtractor.extract(text) abort dict
    let l:result = []
    for l:line in split(a:text, '\v[\r\n]+')
        let l:m = matchlist(l:line, '\v^\s*at\s+([0-9A-Za-z_.<>]+)\((\w*.java):(\d+)\)$')
        if !empty(l:m)
            let l:methodFullName = l:m[1]
            let l:filename = l:m[2]
            let l:path = self.resolveFilePath(l:methodFullName, l:filename)
            let l:linenum = str2nr(l:m[3])
            call add(l:result, [l:path, l:linenum])
        endif
    endfor
    return reverse(l:result)
endfunction

let g:unstack_extractors = [s:javaExtractor]
let g:unstack_extractors = unstack#extractors#GetDefaults() + [
            \ s:javaExtractor,
            \ ]

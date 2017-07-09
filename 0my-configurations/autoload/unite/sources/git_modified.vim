" Shamelessly stolen from ctrlp-modified.vim

function! unite#sources#git_modified#define() abort
    return s:source
endfunction

let s:source = {
            \ 'name': 'git/modified',
            \ }

function! s:source.gather_candidates(args, context) abort
    let l:candidates = []
    for l:file in systemlist('git status --porcelain --untracked-files=all')
        let l:match = matchlist(l:file, '\v^\s*(\S+)\s*(.*)')
        if !empty(l:match)
            let l:file = l:match[2]
            let l:candidate = {
                        \ 'word': l:file,
                        \ 'kind': isdirectory(l:file) ? 'directory' : 'file',
                        \ 'action__path': unite#util#substitute_path_separator(l:file)
                        \ }
            call add(l:candidates, l:candidate)
        endif
    endfor
    return l:candidates
endfunction

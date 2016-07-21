" Shamelessly stolen from ctrlp-modified.vim

function! unite#sources#git_branch#define() abort
    return s:source
endfunction

let s:source = {
            \ 'name': 'git/branch',
            \ }

function! s:source.gather_candidates(args, context) abort
    let l:candidates = []
    for l:file in systemlist('git diff $(git merge-base origin/HEAD HEAD).. --name-only')
        let l:candidate = {
                    \ 'word': l:file,
                    \ 'kind': isdirectory(l:file) ? 'directory' : 'file',
                    \ 'action__path': unite#util#substitute_path_separator(l:file)
                    \ }
        call add(l:candidates, l:candidate)
    endfor
    return l:candidates
endfunction

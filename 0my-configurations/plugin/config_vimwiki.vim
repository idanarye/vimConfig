let g:vimwiki_map_prefix = '<M-w>'

function! s:wikipageFzf()
    let l:paths = map(copy(g:vimwiki_wikilocal_vars), {i, v -> v['path']})
    let l:paths = uniq(sort(l:paths))
    let l:wikiFiles = globpath(join(l:paths, ','), '**/*.wiki', 0, 1)
    echo fzf#run(fzf#wrap({
                \ 'source': l:wikiFiles,
                \ 'options': fzf#vim#with_preview('up:80%').options,
                \ }, 1))
endfunction

nnoremap <M-p>w :call <SID>wikipageFzf()<Cr>
nnoremap <M-p><M-w> :call <SID>wikipageFzf()<Cr>

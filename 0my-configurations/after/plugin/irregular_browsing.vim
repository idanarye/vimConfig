function! s:startExplorer(path)
    enew
    execute 'CocCommand explorer --no-toggle --position floating --open-action-strategy sourceWindow' a:path
endfunction
augroup MyFileExplorerUsingCocExplorer
    autocmd!
    autocmd BufEnter * if isdirectory(expand('<amatch>')) | call s:startExplorer(expand('<amatch>')) | endif
augroup END

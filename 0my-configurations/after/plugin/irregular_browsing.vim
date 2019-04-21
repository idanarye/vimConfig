augroup MyFileExplorerUsingDefx
    autocmd BufEnter * if isdirectory(expand('<amatch>')) | execute 'Defx -new' expand('<amatch>') | endif
augroup END

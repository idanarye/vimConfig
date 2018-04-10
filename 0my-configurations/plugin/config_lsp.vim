if has('nvim')
            " \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    let g:LanguageClient_serverCommands = extend({
                \ 'rust': systemlist('find ~/.rustup -name rls | grep bin | grep nightly | sort | tail -1'),
                \ 'python': ['pyls'],
                \ 'java': ['java-lang-server'],
                \ }, get(g:, 'LanguageClient_serverCommands', {}))

    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_diagnosticsList = v:null

    function! s:setupLanguage() abort
        if has_key(g:LanguageClient_serverCommands, &filetype)
            ALEDisable
            setlocal signcolumn=yes
            setlocal omnifunc=LanguageClient#complete
            setlocal formatexpr=LanguageClient_textDocument_rangeFormatting()

            nnoremap <buffer> <silent> K :call LanguageClient_textDocument_hover()<CR>
        endif
    endfunction

    autocmd FileType * call s:setupLanguage()

    nnoremap <silent> \d :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> \r :call LanguageClient_textDocument_rename()<CR>
    nnoremap <silent> \n :call LanguageClient_textDocument_references()<CR>
    nnoremap <silent> \a :call LanguageClient_textDocument_codeAction()<Cr>
    " nnoremap <silent> \e :call LanguageClient_workspace_executeCommand()<Cr>
    " nnoremap <silent> \S :call LanguageClient_textDocument_signatureHelp()<Cr>

    nnoremap <silent> \s :call LanguageClient_textDocument_documentSymbol()<Cr>
    command! LCwSymbol call LanguageClient_workspace_symbol()

    function! s:LanguageClient_restart(alive, ...) abort
        if a:alive.result
            LanguageClientStop
        endif
        LanguageClientStart
    endfunction
    command! LCrestart call LanguageClient#alive(function('s:LanguageClient_restart'))
endif

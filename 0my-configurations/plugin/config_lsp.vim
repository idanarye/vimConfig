if has('nvim')
    let g:LanguageClient_serverCommands = extend({
                \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
                \ 'python': ['pyls'],
                \ 'java': ['java-lang-server'],
                \ }, get(g:, 'LanguageClient_serverCommands', {}))

    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_diagnosticsList = ''

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

    function! s:languageClient_restart() abort
        if LanguageClient_alive()
            LanguageClientStop
        endif
            LanguageClientStart
    endfunction
    command! LCrestart call s:languageClient_restart()
endif

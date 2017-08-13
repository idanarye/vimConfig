if has('nvim')
    let g:LanguageClient_serverCommands = extend({
                \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
                \ 'python': ['pyls'],
                \ }, get(g:, 'LanguageClient_serverCommands', {}))
                " \ 'java': ['java-lang-server'],

    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_diagnosticsList = ''

    function! s:setupLanguage() abort
        if has_key(g:LanguageClient_serverCommands, &filetype)
            ALEDisable
            setlocal omnifunc=LanguageClient#complete
            setlocal formatexpr=LanguageClient_textDocument_rangeFormatting()

            nnoremap <buffer> <silent> K :call LanguageClient_textDocument_hover()<CR>
        endif
    endfunction

    autocmd FileType * call s:setupLanguage()

    nnoremap <silent> \d :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> \r :call LanguageClient_textDocument_rename()<CR>
    nnoremap <silent> \n :call LanguageClient_textDocument_references()<CR>

    command! LCdSymbol call LanguageClient_textDocument_documentSymbol()
    command! LCwSymbol call LanguageClient_workspace_symbol()
endif

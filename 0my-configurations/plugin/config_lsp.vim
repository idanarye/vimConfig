if !empty(globpath(&runtimepath, 'plugin/LanguageClient.vim'))
            " \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    let g:LanguageClient_serverCommands = extend({
                \ 'rust': systemlist('find ~/.rustup -name rls | grep bin | grep nightly | sort | tail -1'),
                \ 'python': ['pyls'],
                \ 'java': ['java-lang-server'],
                \ 'kotlin': ['kotlin-language-server'],
                \ }, get(g:, 'LanguageClient_serverCommands', {}))

    let g:LanguageClient_rootMarkers = {
                \ 'rust': ['Cargo.toml'],
                \ 'java': ['build.gradle', 'build.gradle.kts'],
                \ 'kotlin': ['build.gradle', 'build.gradle.kts'],
                \ }

    let g:LanguageClient_autoStart = 1
    let g:LanguageClient_diagnosticsList = 'Disabled'
    if has('nvim')
        let s:nvimInstanceDir = matchstr(v:servername, '\v^/tmp/.*\ze/\d+$')
        if !empty(s:nvimInstanceDir)
            let g:LanguageClient_loggingFile = s:nvimInstanceDir . '/languageClient.log'
        endif
    end

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
    nnoremap <silent> \D :call LanguageClient_textDocument_typeDefinition()<CR>
    nnoremap <silent> \r :call LanguageClient_textDocument_rename()<CR>
    nnoremap <silent> \n :call LanguageClient_textDocument_references()<CR>
    nnoremap <silent> \a :call LanguageClient_textDocument_codeAction()<Cr>
    " nnoremap <silent> \e :call LanguageClient_workspace_executeCommand()<Cr>
    " nnoremap <silent> \S :call LanguageClient_textDocument_signatureHelp()<Cr>

    nnoremap <silent> \h :call LanguageClient_textDocument_documentHighlight()<Cr>
    nnoremap <silent> \H :call LanguageClient_clearDocumentHighlight()<Cr>

    nnoremap <silent> \s :call LanguageClient_textDocument_documentSymbol()<Cr>
    nnoremap <silent> \\ :call LanguageClient_contextMenu()<Cr>
    command! LCwSymbol call LanguageClient_workspace_symbol()

    function! s:LanguageClient_restart(alive, ...) abort
        if a:alive.result
            LanguageClientStop
        endif
        LanguageClientStart
    endfunction
    command! LCrestart call LanguageClient#alive(function('s:LanguageClient_restart'))
elseif !empty(globpath(&runtimepath, 'plugin/coc.vim'))
    inoremap <silent><expr> <c-x><c-o> coc#refresh()

    " nmap <silent> \h :call LanguageClient_textDocument_documentHighlight()<Cr>
    " nmap <silent> \H :call LanguageClient_clearDocumentHighlight()<Cr>
    " nmap <silent> \s :call LanguageClient_textDocument_documentSymbol()<Cr>
    " nmap <silent> \\ :call LanguageClient_contextMenu()<Cr>
" <Plug>(coc-diagnostic-info) 			*n_coc-diagnostic-info*

			" Show diagnostic message of current position, no
			" truncate.

" <Plug>(coc-diagnostic-next) 			*n_coc-diagnostic-next*
			
			" Jump to next diagnostic position.

" <Plug>(coc-diagnostic-prev) 			*n_coc-diagnostic-prev*
			
			" Jump to previous diagnostic position.

    " nmap <silent> \d <Plug>(coc-declaration)
    nmap <silent> \d <Plug>(coc-definition)

" <Plug>(coc-declaration) 			*n_coc-declaration*

			" Jump to declaration(s) of current symbol.

" <Plug>(coc-implementation) 			*n_coc-implementation*

			" Jump to implementation(s) of current symbol.

    nmap <silent> \D <Plug>(coc-type-definition)

			" Jump to type definition(s) of current symbol.

    nmap <silent> \n <Plug>(coc-references)
" <Plug>(coc-format-selected) 			*n_coc-format-selected*
						" *v_coc-format-selected*

			" Format selected range, would work in both visual mode
			" and normal mode, when work in normal mode, the
			" selections works on motion object.

	" For example: >

	" vmap <leader>p  <Plug>(coc-format-selected)
	" nmap <leader>p  <Plug>(coc-format-selected)
" <
	" makes `<leader>p` format visual selected range, and you can use
	" `<leader>pap` to format a paragraph.

" <Plug>(coc-format) 				*n_coc-format*

			" Format whole buffer, normally you would like to use a
			" command like: >

	" command! -nargs=0 Format :call CocAction('format')
" <
			" to format current buffer.

    nmap <silent> \r <Plug>(coc-rename)

			" Rename symbol under cursor to a new word.

    nmap <silent> \A <Plug>(coc-codeaction)
    nnoremap <silent> \a :call cocfzf#codeAction()<Cr>

			" Get and run code action(s) for current line.

    vmap <silent> \a <Plug>(coc-codeaction-selected)
" <Plug>(coc-codeaction-selected) 		*n_coc-codeaction-selected*
						" *v_coc-codeaction-selected*

			" Get and run code action(s) with selected region.
			" Works with both normal and visual mode.


" <Plug>(coc-openlink) 				*n_coc-openlink*

			" Open link under cursor.

    nmap <silent> \l <Plug>(coc-codelens)
" <Plug>(coc-codelens-action) 			*n_coc-codelens-action*

			" Do command from codeLens of current line.

    nmap <silent> \f <Plug>(coc-fix-current)
" <Plug>(coc-fix-current) 			*n_coc-fix-current*

			" Try run quickfix action for diagnostics in current
			" line.
endif

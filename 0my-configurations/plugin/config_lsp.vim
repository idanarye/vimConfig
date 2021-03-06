if !has('nvim')
    finish
endif
" let g:completion_enable_auto_popup = 0
" let g:completion_enable_snippet = 'vim-vsnip'

" imap <C-Space> <Plug>(completion_smart_tab)
" inoremap <silent><expr> <C-Space> compe#complete()

nnoremap <silent> \a <cmd>lua vim.lsp.buf.code_action()<CR>
vnoremap <silent> \a :lua vim.lsp.buf.range_code_action()<CR>
" nnoremap <silent> \a <cmd>Telescope lsp_code_actions<CR>
" vnoremap <silent> \a <cmd>Telescope lsp_range_code_actions<CR>

nnoremap <silent> \d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> \D <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> \k <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> \<C-d> <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> \n <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> \0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> \W <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> \<M-d> <cmd>lua vim.lsp.buf.declaration()<CR>

nnoremap <silent> \r <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> \q <cmd> LspDiagnostics 0<CR>
nnoremap <silent> \Q <cmd> LspDiagnosticsAll<CR>

finish
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
    imap <C-l> <Plug>(coc-snippets-expand)
    nnoremap <silent> K :call CocAction('doHover')<CR>
    let g:jedi#documentation_command = ''

    inoremap <silent><expr> <C-Space> coc#refresh()

    nnoremap <silent> \\ :CocList<Cr>
    nnoremap <silent> \c :CocCommand<Cr>

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

    " nmap <silent> \A <Plug>(coc-codeaction)
    " nnoremap <silent> \A :CocAction<Cr>
    " nnoremap <silent> \a :call cocfzf#codeAction()<Cr>
    nnoremap <silent> \A :call cocfzf#codeAction()<Cr>
    " nnoremap <silent> \a :CocList actions<Cr>
    nnoremap <silent> \a :CocCommand actions.open<Cr>

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

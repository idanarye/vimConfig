if !exists('g:inline_edit_patterns')
    let g:inline_edit_patterns = []
endif

			" \ 'main_filetype': 'wekaticket',
call add(g:inline_edit_patterns, {
      \ 'callback':      'myinlineedit#JiraMarkdownFencedCode',
      \ })

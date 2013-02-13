" ============================================================================
" File: autoload/psearch.vim
" Description: A preview for your searches
" Mantainer: Giacomo Comitti (https://github.com/gcmt)
" Url: https://github.com/gcmt/psearch.vim
" License: MIT
" Version: 0.1.0
" Last Changed: 12 Feb 2013
" ============================================================================
"

function! psearch#Init()
    let py_module = fnameescape(globpath(&runtimepath, 'autoload/psearch.py'))
    exe 'pyfile ' . py_module
    py psearch_plugin = PSearch()
endfunction


call psearch#Init()


function! psearch#Open(cword)
    py psearch_plugin.open(vim.eval('a:cword'))
endfunction

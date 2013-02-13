" ============================================================================
" File: plugin/psearch.vim
" Description: A preview for your searches
" Mantainer: Giacomo Comitti (https://github.com/gcmt)
" Url: https://github.com/gcmt/psearch.vim
" License: MIT
" Version: 0.1.0
" Last Changed: 12 Feb 2013
" ============================================================================
"

" Init {{{

if exists('g:pse_disable')
    let s:disable = g:pse_disable
else
    let s:disable = 0
endif

if s:disable || exists("g:pse_loaded") || &cp
    finish
endif

if !has('python')
    echohl WarningMsg | echom "PSearch requires vim to be compiled with Python 2.6+" | echohl None
    finish
endif

if v:version < 702
    echohl WarningMsg | echom "Psearch requires vim 7.2+" | echohl None
    finish
endif

python << END
import vim, sys

if sys.version_info[:2] < (2, 6):
    vim.command("""
    echohl WarningMsg |
    echom "PSearch requires vim to be compiled with Python 2.6+" |
    echohl None
    """)
END

let g:pse_loaded = 1

" }}}


" Settings
let g:pse_prompt = get(g:, 'pse_prompt', ' ❯ ')
let g:pse_max_height = get(g:, 'pse_max_height', 15)

" Commands
command! PSearch call psearch#Open('')
command! PSearchw call psearch#Open(expand('<cword>'))

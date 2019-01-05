let g:vimtex_imaps_leader = "\<C-\>"
let g:vimtex_indent_delims = {
      \ 'open' : ['{', '\\\@<!\\\['],
      \ 'close' : ['}', '\\\]'],
      \ 'include_modified_math' : 1,
      \}

for s:algWord in ['While', 'For', 'Loop', 'Function']
    call add(g:vimtex_indent_delims.open, printf('\\%s\>', s:algWord))
    call add(g:vimtex_indent_delims.close, printf('\\End%s\>', s:algWord))
endfor

let g:vimtex_indent_conditionals = {
      \ 'open': '\v%(\\newif)@<!\\if%(field|name|numequal|thenelse)@!|\\If>',
      \ 'else': '\v\\else>|\\Else>|\\ElsIf>',
      \ 'close': '\v\\fi\>|\\EndIf>',
      \}

let g:vimtex_quickfix_open_on_warning = 0

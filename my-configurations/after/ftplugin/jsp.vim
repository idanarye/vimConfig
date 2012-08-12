setlocal omnifunc=htmlcomplete#CompleteTags

"Indentions
set autoindent
set si
set shiftwidth=4
"Java anonymous classes. Sometimes, you have to use them.
set cinoptions+=j1

exe "runtime! indent/xml.vim"
autocmd BufReadPost *.jsp setlocal indentexpr=XmlIndentGet(v:lnum,1)
autocmd FileType *.jsp let g:test="test2"

finish
"shamelessly stolen from the eruby plugin
set indentexpr=GetJSPIndent()

if exists("b:ejsp_subtype")
  exe "runtime! indent/".b:ejsp_subtype.".vim"
else
  runtime! indent/html.vim
endif
unlet! b:did_indent

if &l:indentexpr == ''
  if &l:cindent
    let &l:indentexpr = 'cindent(v:lnum)'
  else
    let &l:indentexpr = 'indent(prevnonblank(v:lnum-1))'
  endif
endif
let b:ejsp_subtype_indentexpr = &l:indentexpr


function! GetJSPIndent(...)
  if a:0 && a:1 == '.'
    let v:lnum = line('.')
  elseif a:0 && a:1 =~ '^\d'
    let v:lnum = a:1
  endif
  let vcol = col('.')
  call cursor(v:lnum,1)
  let injsp = searchpair('<%','','%>','W')
  call cursor(v:lnum,vcol)
  if injsp && getline(v:lnum) !~ '^<%\|^\s*-\=%>'
    let ind = GetRubyIndent()
  else
    exe "let ind = ".b:ejsp_subtype_indentexpr
  endif
  let lnum = prevnonblank(v:lnum-1)
  let line = getline(lnum)
  let cline = getline(v:lnum)
  if cline =~# '^\s*<%-\=\s*\%(}\|end\|else\|\%(ensure\|rescue\|elsif\|when\).\{-\}\)\s*\%(-\=%>\|$\)'
    let ind = ind - &sw
  endif
  if line =~# '\S\s*<%-\=\s*\%(}\|end\).\{-\}\s*\%(-\=%>\|$\)'
    let ind = ind - &sw
  endif
  if line =~# '\%({\|\<do\)\%(\s*|[^|]*|\)\=\s*-\=%>'
    let ind = ind + &sw
  elseif line =~# '<%-\=\s*\%(module\|class\|def\|if\|for\|while\|until\|else\|elsif\|case\|when\|unless\|begin\|ensure\|rescue\)\>.*%>'
    let ind = ind + &sw
  endif
  if line =~# '^\s*<%[=#-]\=\s*$' && cline !~# '^\s*end\>'
    let ind = ind + &sw
  endif
  if cline =~# '^\s*-\=%>\s*$'
    let ind = ind - &sw
  endif
  return ind
endfunction


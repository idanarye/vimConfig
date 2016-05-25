"copied from the java ftplugin
" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql
" Set 'comments' to format dashed lists in comments. Behaves just like C.
"setlocal comments^=sr:/+,mb:+,ex:+/
setlocal smartindent
setlocal autoindent
setlocal commentstring=//%s

"nnoremap <buffer> K :DUddoc<Cr>
nnoremap <buffer> K :DUddoc<Cr>
nnoremap <buffer> <LocalLeader>d :DUjump<Cr>
nnoremap <buffer> <LocalLeader>D :DUjump!<Cr>

nnoremap <buffer> <LocalLeader>s :DUsyntaxCheck %<Cr>
nnoremap <buffer> <LocalLeader>f :DUstyleCheck %<Cr>

nnoremap <buffer> <LocalLeader>u :DUupdateCTags %<Cr>

nnoremap <buffer> <LocalLeader><C-d>l :DUDCDstartServer<Cr>
nnoremap <buffer> <LocalLeader><C-d>k :DUDCDstopServer<Cr>
nnoremap <buffer> <LocalLeader><C-d>c :DUDCDclearCache<Cr>
nnoremap <buffer> <LocalLeader><C-d>r :DUDCDrestartServer<Cr>

set foldmethod=syntax

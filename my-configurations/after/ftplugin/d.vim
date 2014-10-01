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
nnoremap <buffer> <LocalLeader>d :DUddoc<Cr>
nnoremap <buffer> <LocalLeader>j :DUjump<Cr>
nnoremap <buffer> <LocalLeader>J :DUjump!<Cr>

nnoremap <buffer> <LocalLeader>s :DUsyntaxCheck %<Cr>
nnoremap <buffer> <LocalLeader>S :DUstyleCheck %<Cr>

nnoremap <buffer> <LocalLeader>u :DUupdateCTags %<Cr>

nnoremap <buffer> <LocalLeader><C-d>l :DUDCDstartServer<Cr>
nnoremap <buffer> <LocalLeader><C-d>k :DUDCDstopServer<Cr>

"copied from the java ftplugin
" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql
" Set 'comments' to format dashed lists in comments. Behaves just like C.
setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/
setlocal commentstring=//%s

setlocal omnifunc=javacomplete#Complete
let g:first_nailgun_port=2114
let g:javacomplete_ng="ng"

"CompleteParamsInfo is not working :(
"setlocal completefunc=javacomplete#CompleteParamsInfo

"Indentions
set autoindent
set si
set shiftwidth=4
"Java anonymous classes. Sometimes, you have to use them.
set cinoptions+=j1

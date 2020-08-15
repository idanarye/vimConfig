function! s:chooseDbuiConnection() abort
    call fzf#run({
                \ 'source': map(db_ui#connections_list(), 'printf("%s\31%s", v:val.name, v:val.url)'),
                \ 'sink': function('s:setDbConnection'),
                \ 'down': '~40%',
                \ 'options': ["--delimiter=\31", '--with-nth=1'],
                \ })
endfunction

function! s:setDbConnection(selection) abort
    let b:db = split(a:selection, "\31")[1]
endfunction

command! DBUISetDbConnection call s:chooseDbuiConnection()

function! s:executeSql(sql) abort
    let l:sql = getline("'[", "']")
    if a:sql == 'line'
    elseif a:sql == 'char'
        let l:sql[-1] = l:sql[-1][:col("']") - 1]
        let l:sql[0] = l:sql[0][col("'[") - 1:]
    else
        throw 'Cannot use with ' . a:sql . ' motion'
    endif
    call db#execute_command('', 0, line("'["), -1, join(l:sql, "\n"))
endfunction

function! s:executeSqlOp() abort
    let &operatorfunc = matchstr(string(function('s:executeSql')), '\vfunction\(''\zs.*\ze''\)')
    return 'g@'
endfunction

nnoremap <expr> gs <SID>executeSqlOp()
nnoremap gss :.DB<Cr>
vnoremap <expr> gs <SID>executeSqlOp()

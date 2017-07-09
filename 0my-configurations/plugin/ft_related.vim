function! GetDNumbers()
    let l:temp_dir = tempname()
    let l:tmp_fname = localtime().'.d'
    call mkdir(l:temp_dir)
    try
        execute 'write '.l:temp_dir.'/'.l:tmp_fname
        return system('cd '.l:temp_dir.' && dscanner --ctags | grep '.l:tmp_fname." | awk '{print $3}' | sed 's/;\"//p' -n | sort -h | uniq")
    finally
        call system('rm -R '.l:temp_dir)
    endtry
endfunction
let g:ttoc_expr_d = 'GetDNumbers()'

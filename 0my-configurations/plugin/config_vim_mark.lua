vim.g.mw_no_mappings = 1

vim.cmd[=[
nmap <Leader>m <Plug>MarkSet
nmap <Leader>M <Plug>MarkPartialWord
xmap <Leader>m <Plug>MarkSet
nmap <Leader>r <Plug>MarkRegex
xmap <Leader>r <Plug>MarkRegex
nmap <Leader>n <Plug>MarkClear
nmap <Leader>* <Plug>MarkSearchCurrentNext
nmap <Leader># <Plug>MarkSearchCurrentPrev
nmap <Leader>/ <Plug>MarkSearchAnyNext
nmap <Leader>? <Plug>MarkSearchAnyPrev
nmap * <Plug>MarkSearchNext
nmap # <Plug>MarkSearchPrev
]=]

" nnoremap <M-d>t <cmd>lua require'dap'.repl.toggle()<cr>
nnoremap <M-d>u <cmd>lua require'dapui'.toggle()<cr>

" nnoremap <silent> <M-d>l <cmd><c-u>call vimspector#Launch()<Cr>
nnoremap <M-d>c <cmd>lua require'dap'.continue()<cr>
nnoremap <M-d>C <cmd>lua require'dap'.run_to_cursor()<cr>
nnoremap <M-d>k <cmd>lua require'dap'.close()<cr>
" nmap <M-d>r <Plug>VimspectorRestart
" nnoremap <silent> <M-d>R <cmd><c-u>call vimspector#Reset()<Cr>
" nmap <M-d>p <Plug>VimspectorPause
nnoremap <M-d>b <cmd>lua require'dap'.toggle_breakpoint()<cr>
nnoremap <M-d><C-b> <cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
" nmap <M-d><C-b> <Plug>VimspectorToggleConditionalBreakpoint
" nnoremap <silent> <M-d>B <cmd><c-u>call vimspector#ClearBreakpoints()<Cr>

nnoremap <M-d>o <cmd>lua require'dap'.step_over()<cr>
nnoremap <M-d>i <cmd>lua require'dap'.step_into()<cr>
nnoremap <M-d>O <cmd>lua require'dap'.step_out()<cr>

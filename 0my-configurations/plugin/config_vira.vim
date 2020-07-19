let g:vira_config_file_servers = '/home/idanarye/.config/vira/vira_servers.yaml'
let g:vira_config_file_projects = '/home/idanarye/.config/vira/vira_projects.yaml'

" Basics
nnoremap <silent> <leader>jI :ViraIssue<cr>
nnoremap <silent> <leader>jS :ViraServers<cr>
nnoremap <silent> <leader>jT :ViraTodo<cr>
nnoremap <silent> <leader>jb :ViraBrowse<cr>
nnoremap <silent> <leader>jc :ViraComment<cr>
nnoremap <silent> <leader>je :ViraEpics<cr>
nnoremap <silent> <leader>ji :ViraIssues<cr>
nnoremap <silent> <leader>jr :ViraReport<cr>
nnoremap <silent> <leader>jt :ViraTodos<cr>

" Sets
nnoremap <silent> <leader>jsa :ViraSetAssignee<cr>
nnoremap <silent> <leader>jsp :ViraSetPriority<cr>
nnoremap <silent> <leader>jss :ViraSetStatus<cr>
nnoremap <silent> <leader>jsv :ViraSetVersion<cr>

" Edits
nnoremap <silent> <leader>jed :ViraEditDescription<cr>
nnoremap <silent> <leader>jes :ViraEditSummary<cr>

" Filter search
nnoremap <silent> <leader>jfR :ViraFilterReset<cr>

nnoremap <silent> <leader>j/ :ViraFilterText<cr>

nnoremap <silent> <leader>jfP :ViraFilterPriorities<cr>
nnoremap <silent> <leader>jfa :ViraFilterAssignees<cr>
nnoremap <silent> <leader>jfp :ViraFilterProjects<cr>
nnoremap <silent> <leader>jfr :ViraFilterReporters<cr>
nnoremap <silent> <leader>jfs :ViraFilterStatuses<cr>
nnoremap <silent> <leader>jft :ViraFilterTypes<cr>

" Keymaps for commands that don't have a keymap in the copy-paste list in the readme

nnoremap <silent> <leader>jq :ViraQuit<cr>
nnoremap <silent> <leader>jec :ViraEditComment<cr>
nnoremap <silent> <leader>jfc :ViraFilterComponents<cr>
nnoremap <silent> <leader>jfv :ViraFilterVersions<cr>
nnoremap <silent> <leader>jR :ViraRefresh<cr>
nnoremap <silent> <leader>jsc :ViraSetComponent<cr>
nnoremap <silent> <leader>jst :ViraSetType<cr>

" Status
" statusline+=%{ViraStatusline()}

function! myconfig_defx#setup() abort

    nnoremap <silent><buffer><expr><nowait> o defx#do_action('call', 'myconfig_defx#openAction')
    nnoremap <silent><buffer><expr><nowait> <Cr> defx#do_action('call', 'myconfig_defx#openAction')

    nnoremap <silent><buffer><expr><nowait> i defx#do_action('drop', 'split')
    nnoremap <silent><buffer><expr><nowait> s defx#do_action('drop', 'vsplit')
    nnoremap <silent><buffer><expr><nowait> t defx#do_action('drop', 'tabnew')

    " nnoremap <silent><buffer><expr><nowait> <CR> defx#do_action('open')
    nnoremap <silent><buffer><expr><nowait> c defx#do_action('copy')
    nnoremap <silent><buffer><expr><nowait> m defx#do_action('move')
    nnoremap <silent><buffer><expr><nowait> p defx#do_action('paste')
    " nnoremap <silent><buffer><expr><nowait> l defx#do_action('open')
    nnoremap <silent><buffer><expr><nowait> E defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr><nowait> P defx#do_action('open', 'pedit')
    " nnoremap <silent><buffer><expr><nowait> o defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr><nowait> K defx#do_action('new_directory')
    nnoremap <silent><buffer><expr><nowait> N defx#do_action('new_file')
    nnoremap <silent><buffer><expr><nowait> M defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr><nowait> C defx#do_action('toggle_columns', 'mark:filename:type:size:time')
    nnoremap <silent><buffer><expr><nowait> S defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr><nowait> d defx#do_action('remove')
    nnoremap <silent><buffer><expr><nowait> r defx#do_action('rename')
    " nnoremap <silent><buffer><expr><nowait> !  defx#do_action('execute_command')
    nnoremap <silent><buffer><expr><nowait> x defx#do_action('execute_system')
    nnoremap <silent><buffer><expr><nowait> yy defx#do_action('yank_path')
    nnoremap <silent><buffer><expr><nowait> .  defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr><nowait> ; defx#do_action('repeat')
    " nnoremap <silent><buffer><expr><nowait> h defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr><nowait> <BS> defx#do_action('cd', ['..'])
    " nnoremap <silent><buffer><expr><nowait> ~ defx#do_action('cd')
    nnoremap <silent><buffer><expr><nowait> q defx#do_action('quit')
    nnoremap <silent><buffer><expr><nowait> <Space> defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr><nowait> * defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr><nowait> j line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr><nowait> k line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr><nowait> <C-l> defx#do_action('redraw')
    nnoremap <silent><buffer><expr><nowait> <C-g> defx#do_action('print')
    " nnoremap <silent><buffer><expr><nowait> cd defx#do_action('change_vim_cwd')


endfunction

function! myconfig_defx#openAction(ctx) abort
    if defx#is_directory()
        call defx#call_action('open_or_close_tree')
    elseif b:defx.context.new
        " elseif a:ctx.split == 'no'
        call defx#call_action('open')
    else
        call defx#call_action('drop')
    endif
endfunction


augroup MyDefxKeymaps
    autocmd!
    autocmd FileType defx call myconfig_defx#setup()
augroup END

call defx#custom#option('_', {
            \ 'winwidth': 31,
            \ 'columns': 'git:mark:icons:filename:type:size:time',
            \ })

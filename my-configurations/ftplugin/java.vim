nmap <silent> <buffer> <LocalLeader>I <Plug>(JavaComplete-Imports-AddMissing)
nmap <silent> <buffer> <LocalLeader>R <Plug>(JavaComplete-Imports-RemoveUnused)
nmap <silent> <buffer> <LocalLeader>i <Plug>(JavaComplete-Imports-AddSmart)
nmap <silent> <buffer> <LocalLeader>ii <Plug>(JavaComplete-Imports-Add)

imap <silent> <buffer> <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
imap <silent> <buffer> <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
imap <silent> <buffer> <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
imap <silent> <buffer> <C-j>ii <Plug>(JavaComplete-Imports-Add)

nmap <silent> <buffer> <LocalLeader>M <Plug>(JavaComplete-Generate-AbstractMethods)

imap <silent> <buffer> <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)

nmap <silent> <buffer> <LocalLeader>A <Plug>(JavaComplete-Generate-Accessors)
nmap <silent> <buffer> <LocalLeader>s <Plug>(JavaComplete-Generate-AccessorSetter)
nmap <silent> <buffer> <LocalLeader>g <Plug>(JavaComplete-Generate-AccessorGetter)
nmap <silent> <buffer> <LocalLeader>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
nmap <silent> <buffer> <LocalLeader>ts <Plug>(JavaComplete-Generate-ToString)
nmap <silent> <buffer> <LocalLeader>eq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
nmap <silent> <buffer> <LocalLeader>c <Plug>(JavaComplete-Generate-Constructor)
nmap <silent> <buffer> <LocalLeader>cc <Plug>(JavaComplete-Generate-DefaultConstructor)

imap <silent> <buffer> <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
imap <silent> <buffer> <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
imap <silent> <buffer> <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

vmap <silent> <buffer> <LocalLeader>s <Plug>(JavaComplete-Generate-AccessorSetter)
vmap <silent> <buffer> <LocalLeader>g <Plug>(JavaComplete-Generate-AccessorGetter)
vmap <silent> <buffer> <LocalLeader>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

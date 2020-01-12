Plug 'AndrewRadev/linediff.vim'
Plug 'arecarn/crunch'
Plug 'artur-shaik/vim-javacomplete2'
if has('nvim')
    " Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
    " Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
endif
Plug 'bitc/vim-bad-whitespace'
" Plug 'bling/vim-airline'
Plug 'briancollins/vim-jst'
Plug 'chrisbra/csv.vim'
Plug 'cloudhead/neovim-fuzzy'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'derekwyatt/vim-scala'
Plug 'deris/vim-rengbang'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'djjcast/mirodark'
Plug 'dyng/ctrlsf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'fadein/FIGlet.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'FooSoft/vim-argwrap'
Plug 'gabemc/powershell-vim'
Plug 'groenewege/vim-less'
Plug 'guns/vim-clojure-static'
Plug 'honza/vim-snippets'
Plug 'idanarye/breeze.vim'
Plug 'idanarye/psearch.vim'
Plug 'int3/vim-extradite'
Plug 'jasoncodes/ctrlp-modified.vim'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'jiangmiao/simple-javascript-indenter'
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'junegunn/vim-easy-align'
Plug 'KabbAmine/lazyList.vim'
Plug 'kablamo/vim-git-log'
Plug 'kana/vim-operator-user'
Plug 'Lokaltog/vim-easymotion'
" Plug 'luochen1990/rainbow', { 'commit': '85d262156fd3c0556b91c88e2b72f93d7d00b729' }
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-swap'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'mihaifm/bufstop'
Plug 'moll/vim-bbye'
Plug 'peterhoeg/vim-qml'
Plug 'powerman/vim-plugin-AnsiEsc'
" Plug 'racer-rust/vim-racer'
Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdcommenter'
" Plug 'scrooloose/nerdtree'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite.vim'
" Plug 'Shougo/denite.nvim'
Plug 'Shougo/vimproc', { 'do': 'make -B' }
Plug 'Shougo/vimshell'
" Plug 'SirVer/ultisnips'

" Plug 'idanarye/vim-easyclip', { 'branch': 'fix-HasMapping-for-buffer-local-maps' }
Plug 'svermeulen/vim-easyclip'

Plug 't9md/vim-textmanip'
Plug 'tmhedberg/SimpylFold'
Plug 'tommcdo/vim-exchange'
Plug 'tommcdo/vim-ninja-feet'
Plug 'tomtom/tlib_vim'
Plug 'tomtom/ttoc_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'udalov/kotlin-vim'
" Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/AdvancedSorters'
Plug 'vim-scripts/aspnetcs'
Plug 'vim-scripts/dbext.vim'
Plug 'vim-scripts/keepcase.vim'
Plug 'vim-scripts/mlessnau_case'
Plug 'vim-scripts/roo.vim'
Plug 'vim-scripts/Tabmerge'
Plug 'vim-scripts/vim-gradle'
" Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wellle/visual-split.vim'
Plug 'Yggdroot/indentLine'
Plug 'zenbro/mirror.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'lervag/vimtex'
Plug 'ron-rs/ron.vim'
Plug 'voldikss/vim-browser-search'
Plug 'vimwiki/vimwiki'
Plug 'mattboehm/vim-unstack'
Plug 'cespare/vim-toml'
" Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
" Plug 'blindFS/vim-taskwarrior'
" Plug 'tbabej/taskwiki'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'samoshkin/vim-mergetool'
Plug 'thinca/vim-themis'
Plug 'liuchengxu/vista.vim'
if has('nvim')
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'kristijanhusak/defx-icons'
Plug 'kristijanhusak/defx-git'
Plug 'rhysd/git-messenger.vim'
Plug 'rbong/vim-crystalline'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
let g:my_coc_extensions = [
            \ 'coc-java',
            \ 'coc-json',
            \ 'coc-python',
            \ 'coc-rust-analyzer',
            \ 'coc-snippets',
            \ 'coc-tabnine',
            \ 'coc-git',
            \ 'coc-yaml',
            \ ]
Plug 'AndrewRadev/inline_edit.vim'
Plug 'kkoomen/vim-doge'
Plug 'KnoP-01/tortus'
Plug 'tpope/vim-rhubarb'
Plug 'tommcdo/vim-fubitive'
Plug 'psliwka/vim-smoothie'
Plug 'wellle/context.vim'
Plug 'dstein64/vim-win'


Plug 'idanarye/vim-casetrate', { 'branch': 'develop' }
Plug 'idanarye/vim-dutyl', { 'branch': 'develop' }
Plug 'idanarye/vim-erroneous', { 'branch': 'develop' }
Plug 'idanarye/vim-integrake', { 'branch': 'develop' }
Plug 'idanarye/vim-makecfg'
Plug 'idanarye/vim-merginal', { 'branch': 'develop' }
Plug 'idanarye/vim-omnipytent', { 'branch': 'develop' }
Plug 'idanarye/vim-omnipytent-extra', { 'branch': 'develop' }
Plug 'idanarye/vim-smile', { 'branch': 'develop' }
Plug 'idanarye/vim-terminalogy'
Plug 'idanarye/vim-vebugger', { 'branch': 'develop' }
Plug 'idanarye/vim-yankitute'
Plug 'idanarye/vim-tabnine-completefunc'

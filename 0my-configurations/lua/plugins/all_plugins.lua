return {
    'AndrewRadev/linediff.vim',
    'arecarn/crunch',
    'artur-shaik/vim-javacomplete2',
    'briancollins/vim-jst',
    'chrisbra/csv.vim',
    'cloudhead/neovim-fuzzy',
    'ctrlpvim/ctrlp.vim',
    'derekwyatt/vim-scala',
    'deris/vim-rengbang',
    'inkarkat/vim-ingo-library',
    'inkarkat/vim-mark',
    'djjcast/mirodark',
    'dyng/ctrlsf.vim',
    'fadein/FIGlet.vim',
    'FooSoft/vim-argwrap',
    'gabemc/powershell-vim',
    'groenewege/vim-less',
    'guns/vim-clojure-static',
    'honza/vim-snippets',
    'idanarye/breeze.vim',
    'idanarye/psearch.vim',
    'int3/vim-extradite',
    'jasoncodes/ctrlp-modified.vim',
    'jeetsukumaran/vim-indentwise',
    'jiangmiao/simple-javascript-indenter',
    'junegunn/fzf.vim',
    'pbogut/fzf-mru.vim',
    'junegunn/vim-easy-align',
    'KabbAmine/lazyList.vim',
    'kablamo/vim-git-log',
    'kana/vim-operator-user',
    'luochen1990/rainbow',
    'machakann/vim-swap',
    'mihaifm/bufstop',
    'moll/vim-bbye',
    'peterhoeg/vim-qml',
    'rking/ag.vim',
    'rust-lang/rust.vim',
    'scrooloose/nerdcommenter',
    'Shougo/neomru.vim',
    {'Shougo/vimproc', build = 'make -B'},
    'Shougo/vimshell',

    'svermeulen/vim-easyclip',

    't9md/vim-textmanip',
    'tmhedberg/SimpylFold',
    'tommcdo/vim-exchange',
    'tommcdo/vim-ninja-feet',
    'tomtom/tlib_vim',
    'tpope/vim-eunuch',
    'tpope/vim-fireplace',
    'tpope/vim-fugitive',
    'tpope/vim-rails',
    'tpope/vim-repeat',
    'tpope/vim-rsi',
    -- 'tpope/vim-scriptease',
    'tpope/vim-sleuth',
    'kylechui/nvim-surround',
    'tpope/vim-unimpaired',
    'udalov/kotlin-vim',
    'vim-ruby/vim-ruby',
    'vim-scripts/AdvancedSorters',
    'vim-scripts/aspnetcs',
    'vim-scripts/keepcase.vim',
    'vim-scripts/mlessnau_case',
    'vim-scripts/roo.vim',
    'vim-scripts/Tabmerge',
    'vim-scripts/vim-gradle',
    'wellle/targets.vim',
    'wellle/visual-split.vim',
    'Yggdroot/indentLine',
    'zenbro/mirror.vim',
    'hynek/vim-python-pep8-indent',
    'lervag/vimtex',
    'ron-rs/ron.vim',
    'voldikss/vim-browser-search',
    'mattboehm/vim-unstack',
    'cespare/vim-toml',
    'rafi/awesome-vim-colorschemes',
    'samoshkin/vim-mergetool',
    'thinca/vim-themis',
    'rhysd/git-messenger.vim',
    'nvim-lualine/lualine.nvim',
    'AndrewRadev/inline_edit.vim',
    'kkoomen/vim-doge',
    'EdenEast/nightfox.nvim',
    'tpope/vim-rhubarb',
    'psliwka/vim-smoothie',
    'dstein64/vim-win',
    'zsugabubus/vim-jumpmotion',
    'da-x/name-assign.vim',
    'rraks/pyro',
    'whiteinge/diffconflicts',
    'tpope/vim-dadbod',
    'kristijanhusak/vim-dadbod-ui',
    {'mg979/vim-visual-multi', branch = 'master'},

    -- if has('nvim')
    'nvim-lua/lsp_extensions.nvim',
    'nvim-lua/popup.nvim',

    -- 'nvim-lua/plenary.nvim',
    {'idanarye/plenary.nvim', branch = 'async-testing'},

    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'tamago324/nlsp-settings.nvim',
    'kyazdani42/nvim-web-devicons', -- for file icons
    {'nvim-treesitter/nvim-treesitter', priority = 100, build = ':TSUpdate'},
    'nvim-treesitter/playground',
    'nvim-telescope/telescope.nvim',
    'lewis6991/gitsigns.nvim',
    {'ray-x/guihua.lua', build = 'cd lua/fzy && make'},
    'onsails/lspkind-nvim',
    'rafcamlet/nvim-luapad',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'mfussenegger/nvim-dap-python',

    'pwntester/octo.nvim',

    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-calc',
    'hrsh7th/nvim-cmp',
    'lukas-reineke/cmp-under-comparator',
    'rcarriga/cmp-dap',

    'ray-x/lsp_signature.nvim',

    'gfanto/fzf-lsp.nvim',

    {'glacambre/firenvim', build = function()
        vim.fn'firenvim#install'(0)
    end},

    'jose-elias-alvarez/null-ls.nvim',

    'ncm2/float-preview.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-neo-tree/neo-tree.nvim',
    's1n7ax/nvim-window-picker',
    'akinsho/git-conflict.nvim',
    'jbyuki/venn.nvim',

    {'ibhagwan/fzf-lua', branch = 'main'},
    'simrat39/rust-tools.nvim',
    {'saecki/crates.nvim', tag = 'v0.3.0'},
    'kevinhwang91/promise-async',
    'kevinhwang91/nvim-ufo',
    'ggandor/leap.nvim',
    'AckslD/nvim-FeMaco.lua',
    'phaazon/mind.nvim',
    'sindrets/diffview.nvim',
    'johnfrankmorgan/whitespace.nvim',

    'nvim-neotest/neotest',
    'nvim-neotest/neotest-plenary',
    'nvim-neotest/neotest-python',
    'rouge8/neotest-rust',
    -- endif
    'rafamadriz/friendly-snippets',
    'L3MON4D3/LuaSnip',

    'mrbjarksen/neo-tree-diagnostics.nvim',
    'SmiteshP/nvim-navic',
    'utilyre/barbecue.nvim',

    'nanozuki/tabby.nvim',
    'stevearc/aerial.nvim',

    'Nexmean/caskey.nvim',

    'epwalsh/obsidian.nvim',
}

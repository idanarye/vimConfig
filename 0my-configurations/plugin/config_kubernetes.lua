local kubectl = require'kubectl'
kubectl.setup {
}

require'caskey'.setup {
    mode = {'n'},
    name = 'kubectl',
    ['<Leader>k'] = {
        act = kubectl.open,
        desc = 'Toggle kubectl.nvim',
    }
}

vim.api.nvim_create_user_command('KubeSelectConfigFile', function()
    require'fzf-lua'.fzf_exec(function(cb)
        local pattern = vim.regex[=[^kube.*.yaml$]=]
        for path, typ in vim.fs.dir('~') do
            if typ == 'file' and pattern:match_str(path) then
                cb(vim.fn.fnamemodify('~/' .. path, ':p'))
            end
        end
        cb()
    end,
    {
        preview = function(path)
            return vim.system({'nu', '-c', [=[ls $env.INPUT | first]=]
        }, {
            env = {INPUT = path[1]},
        }):wait().stdout
    end,
    actions = {
        default = function(path)
            vim.env.KUBECONFIG = path[1]
        end,
    },
})
end, {})

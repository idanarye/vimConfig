local kubectl = require'kubectl'
kubectl.setup {
}

require'caskey'.setup {
    mode = {'n'},
    name = 'kubectl',
    ['<Leader>k'] = {
        act = function()
            if not vim.env.KUBECONFIG then
                vim.notify('$KUBECONFIG is not set. Please run the :KubeSelectConfigFile command', vim.log.levels.WARN)
                return
            end
            local known_resource_types = vim.tbl_keys(require'kubectl.cache'.cached_api_resources.values)
            if next(known_resource_types) == nil then
                kubectl.open()
            else
                require'moonicipal.util'.defer_to_coroutine(function()
                    local resource_type = require'moonicipal'.select(known_resource_types, {
                    })
                    if resource_type then
                        vim.cmd.Kubectl('get', resource_type)
                    end
                end)
            end
        end,
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

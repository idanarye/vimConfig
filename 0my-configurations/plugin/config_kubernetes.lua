if 'https://github.com/Ramilito/kubectl.nvim/issues/707' then
    return
end
local kubectl = require'kubectl'
kubectl.setup {
    headers = {
        enabled = false,
    }
}

local function select_kubeconfig_file()
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
            return vim.system({'nu', '-c', [=[ls $env.INPUT | first]=]}, {
                env = {INPUT = path[1]},
            }):wait().stdout
        end,
        actions = {
            default = function(path)
                vim.env.KUBECONFIG = path[1]
            end,
        },
    })
end

vim.api.nvim_create_user_command('KubeSelectConfigFile', select_kubeconfig_file, {})

require'caskey'.setup {
    mode = {'n'},
    name = 'kubectl',
    ['<Leader>k'] = {
        ['o'] = {
            act = function()
                if vim.env.KUBECONFIG then
                    kubectl.open()
                else
                    vim.notify('$KUBECONFIG is not set. Please run the :KubeSelectConfigFile command', vim.log.levels.WARN)
                end
            end,
            desc = 'Open kubectl.nvim',
        },
        ['r'] = {
            act = function()
                local known_resource_types = vim.tbl_keys(require'kubectl.cache'.cached_api_resources.values)
                if next(known_resource_types) == nil then
                    return
                end
                require'moonicipal.util'.defer_to_coroutine(function()
                    local resource_type = require'moonicipal'.select(known_resource_types, {
                    })
                    if resource_type then
                        vim.cmd.Kubectl('get', resource_type)
                    end
                end)
            end,
            desc = 'Choose Kubernetes resource',
        },
        ['c'] = {
            act = select_kubeconfig_file,
            desc = 'Choose KUBECONFIG file',
        }
    }
}
